using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Net;
using System.Net.Http;
using System.Net.NetworkInformation;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;

namespace NetWatch
{
    public partial class MainWindow : Window
    {
        // ── Backend API endpoints (same as Android app) ──────────────────────
        private const string DOMAIN_INTEL_URL = "https://superagent-cfb25b3e.base44.app/functions/domainIntel";
        private const string IP_WHOIS_URL     = "https://superagent-cfb25b3e.base44.app/functions/ipWhois";

        // ── TLD discovery for smart domain search ──────────────────────────
        private static readonly string[] CommonTlds = {
            ".com", ".net", ".org", ".io", ".co", ".dev", ".app", ".ai",
            ".tech", ".cloud", ".info", ".biz", ".online", ".site",
            ".store", ".xyz", ".me", ".tv", ".gg", ".sh"
        };

        private static readonly HttpClient Http = new HttpClient
        {
            Timeout = TimeSpan.FromSeconds(20)
        };

        // ── Domain Checker categories (same as Android app) ─────────────────
        private static readonly List<CheckerCategory> CheckerDomains = new()
        {
            new CheckerCategory("🔵 Google", new[]
            {
                ("Google Search",    "google.com"),
                ("Google DNS",        "8.8.8.8"),
                ("Gmail",             "mail.google.com"),
                ("Google Drive",      "drive.google.com"),
                ("YouTube",           "youtube.com"),
                ("Google Play",       "play.google.com"),
                ("Google APIs",       "googleapis.com"),
            }),
            new CheckerCategory("🟠 Microsoft", new[]
            {
                ("Bing",              "bing.com"),
                ("Outlook / Exchange","outlook.office365.com"),
                ("OneDrive",          "onedrive.live.com"),
                ("Teams",             "teams.microsoft.com"),
                ("Azure",             "azure.microsoft.com"),
                ("Microsoft CDN",     "msftconnecttest.com"),
            }),
            new CheckerCategory("🟡 Cloudflare", new[]
            {
                ("Cloudflare DNS 1",  "1.1.1.1"),
                ("Cloudflare DNS 2",  "1.0.0.1"),
                ("Cloudflare Web",    "cloudflare.com"),
                ("WARP / DoH",        "cloudflare-dns.com"),
            }),
            new CheckerCategory("🟣 Social & Messaging", new[]
            {
                ("Facebook",          "facebook.com"),
                ("Instagram",         "instagram.com"),
                ("WhatsApp",          "web.whatsapp.com"),
                ("Twitter / X",       "x.com"),
                ("Telegram",          "telegram.org"),
                ("LinkedIn",          "linkedin.com"),
                ("TikTok",            "tiktok.com"),
                ("Reddit",            "reddit.com"),
                ("GitHub",            "github.com"),
            }),
            new CheckerCategory("🔴 Streaming", new[]
            {
                ("Netflix",           "netflix.com"),
                ("Hulu",              "hulu.com"),
                ("Spotify",           "spotify.com"),
                ("Twitch",            "twitch.tv"),
                ("Apple iCloud",      "icloud.com"),
            }),
            new CheckerCategory("🟢 CDN / Infrastructure", new[]
            {
                ("Akamai",            "akamai.com"),
                ("Fastly",            "fastly.com"),
                ("Amazon AWS",        "aws.amazon.com"),
                ("Quad9 DNS",         "9.9.9.9"),
                ("OpenDNS",           "208.67.222.222"),
            }),
            new CheckerCategory("🏦 Finance & Payments", new[]
            {
                ("PayPal",            "paypal.com"),
                ("Stripe",            "stripe.com"),
                ("Visa",              "visa.com"),
                ("Mastercard",        "mastercard.com"),
                ("Wise",              "wise.com"),
                ("Tangem",            "tangem.com"),
                ("Bitcoin",           "bitcoin.org"),
            }),
            new CheckerCategory("🎮 Gaming", new[]
            {
                ("Xbox Live",         "xbox.com"),
                ("Xbox Services",     "xboxlive.com"),
                ("Xbox CDN",          "xboxlive-ce-retail.com"),
                ("PlayStation",       "playstation.com"),
                ("PSN Network",      "psn.np.com"),
                ("PS Store",          "store.playstation.com"),
                ("PS CDN",            "dl.playstation.net"),
            }),
            new CheckerCategory("🤖 AI Services", new[]
            {
                ("ChatGPT",           "chatgpt.com"),
                ("OpenAI API",        "api.openai.com"),
                ("Gemini",            "gemini.google.com"),
                ("Google AI API",     "generativelanguage.googleapis.com"),
                ("Google AI Studio",  "aistudio.google.com"),
            }),
        };

        public MainWindow()
        {
            InitializeComponent();
            VersionLabel.Text = $"v{System.Reflection.Assembly.GetExecutingAssembly().GetName().Version?.ToString(3) ?? "1.0.0"}";
            BuildCheckerUI();
        }

        // ═════════════════════════════════════════════════════════════════════
        // Tab Switching
        // ═════════════════════════════════════════════════════════════════════

        private void TabDomain_Click(object sender, RoutedEventArgs e)  => SwitchTab(0);
        private void TabChecker_Click(object sender, RoutedEventArgs e) => SwitchTab(1);
        private void TabMyInfo_Click(object sender, RoutedEventArgs e)   => SwitchTab(2);

        private void SwitchTab(int tab)
        {
            TabDomainBtn.Style  = (Style)Resources[tab == 0 ? "TabBtnActive" : "TabBtn"];
            TabCheckerBtn.Style = (Style)Resources[tab == 1 ? "TabBtnActive" : "TabBtn"];
            TabMyInfoBtn.Style   = (Style)Resources[tab == 2 ? "TabBtnActive" : "TabBtn"];

            PageDomain.Visibility  = tab == 0 ? Visibility.Visible : Visibility.Collapsed;
            PageChecker.Visibility = tab == 1 ? Visibility.Visible : Visibility.Collapsed;
            PageMyInfo.Visibility   = tab == 2 ? Visibility.Visible : Visibility.Collapsed;
        }

        // ═════════════════════════════════════════════════════════════════════
        // DOMAIN INTEL
        // ═════════════════════════════════════════════════════════════════════

        private void DomainInput_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter) ScanDomain_Click(sender, e);
        }

        private async void ScanDomain_Click(object sender, RoutedEventArgs e)
        {
            string raw = DomainInput.Text.Trim();
            if (string.IsNullOrEmpty(raw))
            {
                DomainStatus.Text = "Enter a domain first";
                return;
            }

            // Strip protocol
            raw = System.Text.RegularExpressions.Regex.Replace(raw, @"^https?://", "", System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            raw = raw.Split('/')[0].ToLowerInvariant().Trim();

            // Smart search: if no dot, try common TLDs
            if (!raw.Contains("."))
            {
                await DiscoverTlds(raw);
                return;
            }

            string domain = raw;
            await RunDomainScan(domain);
        }

        private async Task RunDomainScan(string domain) => await RunDomainScan(domain, false);

        private async Task RunDomainScan(string domain, bool deep)
        {
            DomainStatus.Text = deep ? $"🔬 Deep scanning {domain}…" : $"⏳ Scanning {domain}…";
            DomainResults.Children.Clear();

            try
            {
                var payload = deep
                    ? JsonSerializer.Serialize(new { domain, deep = true })
                    : JsonSerializer.Serialize(new { domain });
                var content = new StringContent(payload, Encoding.UTF8, "application/json");
                var response = await Http.PostAsync(DOMAIN_INTEL_URL, content);
                var json = await response.Content.ReadAsStringAsync();
                await BuildDomainReport(domain, json);
            }
            catch (Exception ex)
            {
                DomainStatus.Text = $"❌ Error: {ex.Message}";
            }
        }

        // ── TLD Discovery: probe common suffixes when user enters a bare name ─
        private async Task DiscoverTlds(string baseName)
        {
            DomainStatus.Text = $"🔍 Searching TLDs for \"{baseName}\"…";
            DomainResults.Children.Clear();

            AddCard(DomainResults, "🔍 TLD Discovery",
                $"Probing {CommonTlds.Length} common suffixes for \"{baseName}\"…\nDomains that resolve will appear below.", "#00E5FF");

            var found = new List<(string domain, string ip)>();
            var tasks = new List<Task>();

            foreach (string tld in CommonTlds)
            {
                string candidate = baseName + tld;
                tasks.Add(Task.Run(async () =>
                {
                    try
                    {
                        var addrs = await Dns.GetHostAddressesAsync(candidate);
                        if (addrs.Length > 0)
                        {
                            string ip = addrs[0].ToString();
                            lock (found)
                            {
                                found.Add((candidate, ip));
                            }
                        }
                    }
                    catch { /* domain doesn't resolve */ }
                }));
            }

            await Task.WhenAll(tasks);

            // Sort found domains: .com first, then alphabetical
            found.Sort((a, b) =>
            {
                int aPri = Array.IndexOf(CommonTlds, a.domain.Substring(baseName.Length));
                int bPri = Array.IndexOf(CommonTlds, b.domain.Substring(baseName.Length));
                return aPri.CompareTo(bPri);
            });

            // Remove the "probing" card
            DomainResults.Children.Clear();

            if (found.Count == 0)
            {
                DomainStatus.Text = $"❌ No domains found for \"{baseName}\"";
                AddCard(DomainResults, "❌ No Results",
                    $"No TLDs resolved for \"{baseName}\".\nTry entering the full domain (e.g. {baseName}.com).", "#EF5350");
                return;
            }

            DomainStatus.Text = $"✅ Found {found.Count} domain{(found.Count == 1 ? "" : "s")} for \"{baseName}\" — click to scan";

            var header = new TextBlock
            {
                Text = $"DISCOVERED DOMAINS FOR \"{baseName.ToUpper()}"",
                Foreground = (SolidColorBrush)FindResource("AccentBrush"),
                FontSize = 12,
                FontWeight = FontWeights.Bold,
                FontFamily = new FontFamily("Consolas"),
                Margin = new Thickness(0, 0, 0, 6)
            };
            DomainResults.Children.Add(header);

            foreach (var (domain, ip) in found)
            {
                var row = new Border
                {
                    Background = new SolidColorBrush(Color.FromRgb(0x0D, 0x11, 0x17)),
                    CornerRadius = new CornerRadius(4),
                    Padding = new Thickness(10, 8, 10, 8),
                    Margin = new Thickness(0, 0, 0, 4),
                    Cursor = Cursors.Hand,
                    Tag = domain
                };

                var sp = new StackPanel { Orientation = Orientation.Horizontal };

                sp.Children.Add(new TextBlock
                {
                    Text = domain,
                    Foreground = new SolidColorBrush(Color.FromRgb(0x00, 0xE5, 0xFF)),
                    FontSize = 13,
                    FontWeight = FontWeights.Bold,
                    FontFamily = new FontFamily("Consolas"),
                    VerticalAlignment = VerticalAlignment.Center
                });

                sp.Children.Add(new TextBlock
                {
                    Text = $"  →  {ip}",
                    Foreground = new SolidColorBrush(Color.FromRgb(0x78, 0x90, 0x9C)),
                    FontSize = 11,
                    FontFamily = new FontFamily("Consolas"),
                    VerticalAlignment = VerticalAlignment.Center
                });

                sp.Children.Add(new TextBlock
                {
                    Text = "  [click to scan →]",
                    Foreground = new SolidColorBrush(Color.FromRgb(0x54, 0x6E, 0x7A)),
                    FontSize = 10,
                    FontFamily = new FontFamily("Consolas"),
                    VerticalAlignment = VerticalAlignment.Center
                });

                // Deep Scan button
                var deepBtn = new TextBlock
                {
                    Text = "  [🔬 Deep Scan]",
                    Foreground = new SolidColorBrush(Color.FromRgb(0xFF, 0xB3, 0x00)),
                    FontSize = 10,
                    FontWeight = FontWeights.Bold,
                    FontFamily = new FontFamily("Consolas"),
                    VerticalAlignment = VerticalAlignment.Center,
                    Cursor = Cursors.Hand,
                    Tag = domain
                };

                sp.Children.Add(deepBtn);

                row.Child = sp;
                row.MouseLeftButtonUp += async (s, e) =>
                {
                    string d = (string)((Border)s).Tag;
                    DomainInput.Text = d;
                    await RunDomainScan(d);
                };

                deepBtn.MouseLeftButtonUp += async (s, e) =>
                {
                    string d = (string)((TextBlock)s).Tag;
                    DomainInput.Text = d;
                    await RunDomainScan(d, true);
                };

                DomainResults.Children.Add(row);
            }
        }

        private async void BuildDomainReport(string domain, string json)
        {
            try
            {
                using var doc = JsonDocument.Parse(json);
                var root = doc.RootElement;

                // Check for error
                if (root.TryGetProperty("error", out var errProp) && !root.TryGetProperty("ipv4", out _))
                {
                    AddCard(DomainResults, "❌ Error", errProp.GetString() ?? "Unknown error", "#EF5350");
                    DomainStatus.Text = $"❌ {errProp.GetString()}";
                    return;
                }

                // IPv4 addresses with Geo-IP
                var ipLines = new StringBuilder();
                if (root.TryGetProperty("ipv4", out var ipv4) && ipv4.GetArrayLength() > 0)
                {
                    foreach (var ipEl in ipv4.EnumerateArray())
                    {
                        string ip = ipEl.GetString() ?? "";
                        ipLines.AppendLine($"IPv4:  {ip}");
                        // Geo-IP lookup
                        try
                        {
                            var geoResp = await Http.GetStringAsync($"https://ipinfo.io/{ip}/json");
                            using var geoDoc = JsonDocument.Parse(geoResp);
                            var geo = geoDoc.RootElement;
                            string org = geo.TryGetProperty("org", out var o) ? o.GetString() ?? "" : "";
                            string city = geo.TryGetProperty("city", out var c) ? c.GetString() ?? "" : "";
                            string country = geo.TryGetProperty("country", out var cc) ? cc.GetString() ?? "" : "";
                            string countryFull = GetCountryName(country);
                            string flag = GetFlagEmoji(country);
                            if (!string.IsNullOrEmpty(countryFull))
                                ipLines.AppendLine($"       {flag} {countryFull}");
                            if (!string.IsNullOrEmpty(city))
                                ipLines.AppendLine($"       {city}");
                            if (!string.IsNullOrEmpty(org))
                                ipLines.AppendLine($"       {org}");
                            ipLines.AppendLine();
                        }
                        catch { ipLines.AppendLine(); }
                    }
                }

                // IPv6
                if (root.TryGetProperty("ipv6", out var ipv6) && ipv6.GetArrayLength() > 0)
                {
                    foreach (var ipEl in ipv6.EnumerateArray())
                        ipLines.AppendLine($"IPv6:  {ipEl.GetString()}");
                }

                // CNAME
                if (root.TryGetProperty("cname", out var cname) && !string.IsNullOrEmpty(cname.GetString()))
                {
                    string cn = cname.GetString()!;
                    if (cn != "null") ipLines.AppendLine($"CNAME: {cn}");
                }

                // CDN
                if (root.TryGetProperty("cdn", out var cdn) && !string.IsNullOrEmpty(cdn.GetString()))
                {
                    string cdnVal = cdn.GetString()!;
                    if (cdnVal != "null") ipLines.AppendLine($"CDN:   {cdnVal}");
                }

                if (ipLines.Length > 0)
                    AddCard(DomainResults, $"🌐 {domain}", ipLines.ToString().TrimEnd(), "#A5D6A7");

                // Subdomains
                if (root.TryGetProperty("subdomains", out var subs) && subs.GetArrayLength() > 0)
                    AddSubdomainsCard(subs);
                else
                    AddCard(DomainResults, "🌿 Subdomains", "None discovered", "#546E7A");

                // Shared hosts
                if (root.TryGetProperty("sharedHostDomains", out var shared) && shared.GetArrayLength() > 0)
                {
                    var sb = new StringBuilder();
                    foreach (var s in shared.EnumerateArray())
                        sb.AppendLine($"▸  {s.GetString()}");
                    AddCard(DomainResults, $"🕵️ Shared-Host ({shared.GetArrayLength()})", sb.ToString().TrimEnd(), "#FFCC80");
                }
                else
                    AddCard(DomainResults, "🕵️ Shared-Host", "None found", "#546E7A");

                // Cross-domain discovery (from cert SANs + PTR)
                if (root.TryGetProperty("crossDomains", out var cross) && cross.GetArrayLength() > 0)
                {
                    var sb = new StringBuilder();
                    foreach (var c in cross.EnumerateArray())
                    {
                        string cdDomain = c.TryGetProperty("domain", out var d) ? d.GetString() ?? "" : "";
                        bool cdLive = c.TryGetProperty("live", out var l) && l.GetBoolean();
                        string cdCdn = c.TryGetProperty("cdn", out var cd) ? cd.GetString() ?? "" : "";

                        sb.AppendLine($"{(cdLive ? "🟢" : "⚫")}  {cdDomain}");
                        if (c.TryGetProperty("ips", out var cdIps) && cdIps.GetArrayLength() > 0)
                        {
                            var ips = new List<string>();
                            foreach (var ip in cdIps.EnumerateArray())
                                ips.Add(ip.GetString() ?? "");
                            sb.AppendLine($"   {string.Join("  |  ", ips)}");
                        }
                        if (!string.IsNullOrEmpty(cdCdn) && cdCdn != "null")
                            sb.AppendLine($"   CDN: {cdCdn}");
                        sb.AppendLine();
                    }
                    AddCard(DomainResults, $"🔗 Cross-Domain Discovery ({cross.GetArrayLength()})", sb.ToString().TrimEnd(), "#FFB300");
                }

                // Certificate Transparency names
                if (root.TryGetProperty("certNames", out var certNames) && certNames.GetArrayLength() > 0)
                {
                    var sb = new StringBuilder();
                    int showCount = Math.Min(certNames.GetArrayLength(), 30);
                    for (int i = 0; i < showCount; i++)
                        sb.AppendLine($"▸  {certNames[i].GetString()}");
                    if (certNames.GetArrayLength() > 30)
                        sb.AppendLine($"\n  ... +{certNames.GetArrayLength() - 30} more");
                    AddCard(DomainResults, $"📜 Certificate Transparency ({certNames.GetArrayLength()})", sb.ToString().TrimEnd(), "#CE93D8");
                }

                // Status line
                int liveCount = root.TryGetProperty("liveCount", out var lc) ? lc.GetInt32() : 0;
                int totalCount = root.TryGetProperty("totalDiscovered", out var tc) ? tc.GetInt32() : 0;
                string cdnSuffix = "";
                if (root.TryGetProperty("cdn", out var cdn2) && !string.IsNullOrEmpty(cdn2.GetString()) && cdn2.GetString() != "null")
                    cdnSuffix = $"  •  CDN: {cdn2.GetString()}";
                int crossCount = root.TryGetProperty("crossDomains", out var cc) && cc.GetArrayLength() > 0 ? cc.GetArrayLength() : 0;
                string crossSuffix = crossCount > 0 ? $"  •  {crossCount} cross-domains" : "";
                DomainStatus.Text = $"✅  {domain}  •  {liveCount} live / {totalCount} subdomains{cdnSuffix}{crossSuffix}";

                // Deep Scan button at bottom of results
                var deepCard = new Border
                {
                    Background = new SolidColorBrush(Color.FromRgb(0x0D, 0x11, 0x17)),
                    CornerRadius = new CornerRadius(4),
                    Padding = new Thickness(12, 10, 12, 10),
                    Margin = new Thickness(0, 8, 0, 0),
                    Cursor = Cursors.Hand,
                    Tag = domain
                };
                var deepSp = new StackPanel { Orientation = Orientation.Horizontal };
                deepSp.Children.Add(new TextBlock
                {
                    Text = $"🔬  Deep Scan {domain}",
                    Foreground = new SolidColorBrush(Color.FromRgb(0xFF, 0xB3, 0x00)),
                    FontSize = 13,
                    FontWeight = FontWeights.Bold,
                    FontFamily = new FontFamily("Consolas"),
                    VerticalAlignment = VerticalAlignment.Center
                });
                deepSp.Children.Add(new TextBlock
                {
                    Text = "  [certs + subs + PTR →]",
                    Foreground = new SolidColorBrush(Color.FromRgb(0x54, 0x6E, 0x7A)),
                    FontSize = 11,
                    FontFamily = new FontFamily("Consolas"),
                    VerticalAlignment = VerticalAlignment.Center
                });
                deepCard.Child = deepSp;
                deepCard.MouseLeftButtonUp += async (s, e) =>
                {
                    string d = (string)((Border)s).Tag;
                    await RunDomainScan(d, true);
                };
                DomainResults.Children.Add(deepCard);
            }
            catch (Exception ex)
            {
                AddCard(DomainResults, "⚠ Parse Error", ex.Message, "#EF9A9A");
            }
        }

        private void AddSubdomainsCard(JsonElement subs)
        {
            var live = new List<JsonElement>();
            var dead = new List<JsonElement>();

            foreach (var sub in subs.EnumerateArray())
            {
                bool isLive = false;
                if (sub.TryGetProperty("live", out var l) && l.GetBoolean())
                    isLive = true;
                else if (sub.TryGetProperty("ips", out var ips) && ips.GetArrayLength() > 0)
                    isLive = true;
                if (isLive) live.Add(sub); else dead.Add(sub);
            }

            if (live.Count > 0)
            {
                var sb = new StringBuilder();
                for (int i = 0; i < live.Count; i++)
                {
                    var s = live[i];
                    string name = s.TryGetProperty("name", out var n) ? n.GetString() ?? "" : "";
                    sb.AppendLine($"🟢 {name}");
                    if (s.TryGetProperty("ips", out var ips) && ips.GetArrayLength() > 0)
                    {
                        foreach (var ip in ips.EnumerateArray())
                            sb.AppendLine($"   {ip.GetString()}");
                    }
                    if (s.TryGetProperty("cdn", out var c) && !string.IsNullOrEmpty(c.GetString()) && c.GetString() != "null")
                        sb.AppendLine($"   CDN: {c.GetString()}");
                    if (i < live.Count - 1) sb.AppendLine();
                }
                AddCard(DomainResults, $"🟢 LIVE SUBDOMAINS / CDN ({live.Count})", sb.ToString().TrimEnd(), "#00E5FF");
            }

            if (dead.Count > 0)
            {
                var sb = new StringBuilder();
                foreach (var s in dead)
                {
                    string name = s.TryGetProperty("name", out var n) ? n.GetString() ?? "" : "";
                    sb.AppendLine($"▸ {name}");
                }
                AddCard(DomainResults, $"⚫ UNRESOLVED SUBDOMAINS ({dead.Count})", sb.ToString().TrimEnd(), "#546E7A");
            }
        }

        // ═════════════════════════════════════════════════════════════════════
        // DOMAIN CHECKER
        // ═════════════════════════════════════════════════════════════════════

        private readonly Dictionary<string, TextBlock> _checkerStatusViews = new();

        private void BuildCheckerUI()
        {
            foreach (var cat in CheckerDomains)
            {
                // Category header
                var header = new TextBlock
                {
                    Text = cat.Name,
                    Foreground = new SolidColorBrush(Color.FromRgb(0x00, 0xE5, 0xFF)),
                    FontSize = 12,
                    FontWeight = FontWeights.Bold,
                    Margin = new Thickness(0, 14, 0, 6),
                    FontFamily = new FontFamily("Consolas")
                };
                CheckerResults.Children.Add(header);

                foreach (var (label, host) in cat.Entries)
                {
                    var row = new Border
                    {
                        Background = new SolidColorBrush(Color.FromRgb(0x0D, 0x11, 0x17)),
                        CornerRadius = new CornerRadius(4),
                        Padding = new Thickness(10, 6, 10, 6),
                        Margin = new Thickness(0, 2, 0, 2),
                        Cursor = Cursors.Hand
                    };
                    var rowChild = new DockPanel { LastChildFill = true };

                    var labelTb = new TextBlock
                    {
                        Text = label,
                        Foreground = new SolidColorBrush(Color.FromRgb(0xE0, 0xE8, 0xF0)),
                        FontSize = 12,
                        FontFamily = new FontFamily("Consolas"),
                        VerticalAlignment = VerticalAlignment.Center
                    };
                    DockPanel.SetDock(labelTb, Dock.Left);
                    rowChild.Children.Add(labelTb);

                    var statusTb = new TextBlock
                    {
                        Text = "—",
                        Foreground = new SolidColorBrush(Color.FromRgb(0x54, 0x6E, 0x7A)),
                        FontSize = 11,
                        FontFamily = new FontFamily("Consolas"),
                        HorizontalAlignment = HorizontalAlignment.Right,
                        VerticalAlignment = VerticalAlignment.Center
                    };
                    rowChild.Children.Add(statusTb);

                    row.Child = rowChild;
                    row.MouseLeftButtonUp += (s, e) => CheckSingleHost(host, statusTb);

                    CheckerResults.Children.Add(row);
                    _checkerStatusViews[host] = statusTb;
                }
            }
        }

        private void RunAllChecks_Click(object sender, RoutedEventArgs e)
        {
            _ = RunAllChecks();
        }

        private async Task RunAllChecks()
        {
            foreach (var cat in CheckerDomains)
            {
                foreach (var (label, host) in cat.Entries)
                {
                    if (_checkerStatusViews.TryGetValue(host, out var tb))
                        _ = CheckSingleHost(host, tb);
                    await Task.Delay(50); // slight stagger to avoid hammering
                }
            }
        }

        private void CustomCheck_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter) CustomCheck_Click(sender, e);
        }

        private void CustomCheck_Click(object sender, RoutedEventArgs e)
        {
            string raw = CustomCheckInput.Text.Trim();
            if (string.IsNullOrEmpty(raw)) return;
            raw = System.Text.RegularExpressions.Regex.Replace(raw, @"^https?://", "", System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            raw = raw.Split('/')[0].Trim();
            string host = raw;

            // Add custom row at top
            var header = new TextBlock
            {
                Text = "🔎 Custom Checks",
                Foreground = new SolidColorBrush(Color.FromRgb(0x00, 0xE5, 0xFF)),
                FontSize = 12,
                FontWeight = FontWeights.Bold,
                Margin = new Thickness(0, 0, 0, 6),
                FontFamily = new FontFamily("Consolas")
            };

            // Remove existing custom header if present
            for (int i = 0; i < CheckerResults.Children.Count; i++)
            {
                if (CheckerResults.Children[i] is TextBlock t && t.Text == "🔎 Custom Checks")
                {
                    CheckerResults.Children.RemoveAt(i);
                    break;
                }
            }
            CheckerResults.Children.Insert(0, header);

            var row = new Border
            {
                Background = new SolidColorBrush(Color.FromRgb(0x0D, 0x11, 0x17)),
                CornerRadius = new CornerRadius(4),
                Padding = new Thickness(10, 6, 10, 6),
                Margin = new Thickness(0, 2, 0, 2)
            };
            var dp = new DockPanel { LastChildFill = true };
            var labelTb = new TextBlock
            {
                Text = host,
                Foreground = new SolidColorBrush(Color.FromRgb(0xE0, 0xE8, 0xF0)),
                FontSize = 12,
                FontFamily = new FontFamily("Consolas"),
                VerticalAlignment = VerticalAlignment.Center
            };
            DockPanel.SetDock(labelTb, Dock.Left);
            dp.Children.Add(labelTb);

            var statusTb = new TextBlock
            {
                Text = "⏳",
                Foreground = new SolidColorBrush(Color.FromRgb(0xFF, 0xC1, 0x07)),
                FontSize = 11,
                FontFamily = new FontFamily("Consolas"),
                HorizontalAlignment = HorizontalAlignment.Right,
                VerticalAlignment = VerticalAlignment.Center
            };
            dp.Children.Add(statusTb);
            row.Child = dp;
            CheckerResults.Children.Insert(1, row);

            _ = CheckSingleHost(host, statusTb);
        }

        private async Task CheckSingleHost(string host, TextBlock statusTb)
        {
            Dispatcher.Invoke(() =>
            {
                statusTb.Text = "⏳";
                statusTb.Foreground = new SolidColorBrush(Color.FromRgb(0xFF, 0xC1, 0x07));
            });

            var sw = Stopwatch.StartNew();
            bool reachable = false;

            try
            {
                bool isIp = System.Text.RegularExpressions.Regex.IsMatch(host, @"^\d+\.\d+\.\d+\.\d+$");

                if (isIp)
                {
                    // TCP connect to port 53 for IP addresses
                    using var sock = new System.Net.Sockets.TcpClient();
                    await sock.ConnectAsync(host, 53);
                    reachable = true;
                }
                else
                {
                    // DNS resolve
                    await Dns.GetHostAddressesAsync(host);
                    // HTTP HEAD
                    var resp = await Http.SendAsync(new HttpRequestMessage(HttpMethod.Head, $"https://{host}/") { Version = new Version(2, 0) });
                    reachable = resp.IsSuccessStatusCode || (int)resp.StatusCode > 0;
                }
            }
            catch
            {
                // Fallback: try HTTP GET for named hosts
                if (!System.Text.RegularExpressions.Regex.IsMatch(host, @"^\d+\.\d+\.\d+\.\d+$"))
                {
                    try
                    {
                        var resp = await Http.GetAsync($"https://{host}/");
                        reachable = (int)resp.StatusCode > 0;
                    }
                    catch { reachable = false; }
                }
            }

            sw.Stop();
            double ms = sw.Elapsed.TotalMilliseconds;

            Dispatcher.Invoke(() =>
            {
                if (reachable)
                {
                    statusTb.Text = $"✅ {ms:F0}ms";
                    statusTb.Foreground = new SolidColorBrush(Color.FromRgb(0x4C, 0xAF, 0x50));
                }
                else
                {
                    statusTb.Text = "❌";
                    statusTb.Foreground = new SolidColorBrush(Color.FromRgb(0xEF, 0x53, 0x50));
                }
            });
        }

        // ═════════════════════════════════════════════════════════════════════
        // MY INFO
        // ═════════════════════════════════════════════════════════════════════

        private void RefreshMyInfo_Click(object sender, RoutedEventArgs e)
        {
            _ = LoadMyInfo();
        }

        private async Task LoadMyInfo()
        {
            MyInfoResults.Children.Clear();
            AddCard(MyInfoResults, "⏳ Looking up…", "Fetching your public IP and geolocation data.", "#546E7A");

            try
            {
                // 1. Get public IP
                string ip = await Http.GetStringAsync("https://api.ipify.org");

                // 2. Geo enrichment via ipinfo.io
                string geoJson = await Http.GetStringAsync($"https://ipinfo.io/{ip}/json");
                using var geoDoc = JsonDocument.Parse(geoJson);
                var geo = geoDoc.RootElement;

                string isp     = geo.TryGetProperty("org", out var o) ? o.GetString() ?? "" : "";
                string city    = geo.TryGetProperty("city", out var c) ? c.GetString() ?? "" : "";
                string region  = geo.TryGetProperty("region", out var r) ? r.GetString() ?? "" : "";
                string country = geo.TryGetProperty("country", out var cc) ? cc.GetString() ?? "" : "";
                string zip     = geo.TryGetProperty("postal", out var p) ? p.GetString() ?? "" : "";
                string tz      = geo.TryGetProperty("timezone", out var t) ? t.GetString() ?? "" : "";
                string loc     = geo.TryGetProperty("loc", out var l) ? l.GetString() ?? "" : "";
                string lat = "", lon = "";
                if (loc.Contains(","))
                {
                    var parts = loc.Split(',');
                    lat = parts[0]; lon = parts[1];
                }

                string countryFull = GetCountryName(country);
                string flag = GetFlagEmoji(country);

                MyInfoResults.Children.Clear();

                AddCard(MyInfoResults, "🌐 Public IP", ip, "#00E5FF");
                AddCard(MyInfoResults, "📍 Location", $"{flag} {countryFull}\n{city}, {region}" + (string.IsNullOrEmpty(zip) ? "" : $"  {zip}"), "#A5D6A7");

                if (!string.IsNullOrEmpty(isp))
                    AddCard(MyInfoResults, "🏢 ISP / Organization", isp, "#FFCC80");
                if (!string.IsNullOrEmpty(tz))
                    AddCard(MyInfoResults, "🕐 Timezone", tz, "#90A4AE");
                if (!string.IsNullOrEmpty(lat) && !string.IsNullOrEmpty(lon))
                {
                    AddCard(MyInfoResults, "🗺️ Coordinates", $"{lat}, {lon}", "#CE93D8");
                    // Google Maps link button
                    var mapsBtn = new Button
                    {
                        Content = "Open in Google Maps →",
                        Style = (Style)Resources["ActionBtn"],
                        Margin = new Thickness(0, 6, 0, 0),
                        Cursor = Cursors.Hand
                    };
                    mapsBtn.Click += (s, e) =>
                    {
                        Process.Start(new ProcessStartInfo
                        {
                            FileName = $"https://www.google.com/maps?q={lat},{lon}",
                            UseShellExecute = true
                        });
                    };
                    var card = new Border
                    {
                        Background = new SolidColorBrush(Color.FromRgb(0x0D, 0x11, 0x17)),
                        CornerRadius = new CornerRadius(6),
                        Padding = new Thickness(12, 10, 12, 10),
                        Margin = new Thickness(0, 4, 0, 4)
                    };
                    var sp = new StackPanel();
                    sp.Children.Add(new TextBlock
                    {
                        Text = "🗺️ Coordinates",
                        Foreground = new SolidColorBrush(Color.FromRgb(0xCE, 0x93, 0xD8)),
                        FontSize = 11,
                        FontWeight = FontWeights.Bold,
                        Margin = new Thickness(0, 0, 0, 4),
                        FontFamily = new FontFamily("Consolas")
                    });
                    sp.Children.Add(new TextBlock
                    {
                        Text = $"{lat}, {lon}",
                        Foreground = new SolidColorBrush(Color.FromRgb(0xE0, 0xE8, 0xF0)),
                        FontSize = 12,
                        FontFamily = new FontFamily("Consolas"),
                        TextWrapping = TextWrapping.Wrap,
                        Margin = new Thickness(0, 0, 0, 8)
                    });
                    sp.Children.Add(mapsBtn);
                    card.Child = sp;
                    MyInfoResults.Children.Add(card);
                }
            }
            catch (Exception ex)
            {
                MyInfoResults.Children.Clear();
                AddCard(MyInfoResults, "❌ Error", ex.Message, "#EF5350");
            }
        }

        // ═════════════════════════════════════════════════════════════════════
        // UI Helpers
        // ═════════════════════════════════════════════════════════════════════

        private void AddCard(StackPanel container, string title, string body, string accentHex)
        {
            var color = (Color)ColorConverter.ConvertFromString(accentHex);
            var card = new Border
            {
                Background = new SolidColorBrush(Color.FromRgb(0x0D, 0x11, 0x17)),
                CornerRadius = new CornerRadius(6),
                Padding = new Thickness(12, 10, 12, 10),
                Margin = new Thickness(0, 4, 0, 4)
            };
            var sp = new StackPanel();
            sp.Children.Add(new TextBlock
            {
                Text = title,
                Foreground = new SolidColorBrush(color),
                FontSize = 11,
                FontWeight = FontWeights.Bold,
                Margin = new Thickness(0, 0, 0, 4),
                FontFamily = new FontFamily("Consolas")
            });
            sp.Children.Add(new TextBlock
            {
                Text = body,
                Foreground = new SolidColorBrush(Color.FromRgb(0xE0, 0xE8, 0xF0)),
                FontSize = 12,
                FontFamily = new FontFamily("Consolas"),
                TextWrapping = TextWrapping.Wrap
            });
            card.Child = sp;
            container.Children.Add(card);
        }

        private static string GetCountryName(string code)
        {
            if (string.IsNullOrEmpty(code) || code.Length != 2) return code;
            try
            {
                var region = new System.Globalization.RegionInfo(code);
                return region.EnglishName;
            }
            catch { return code; }
        }

        private static string GetFlagEmoji(string countryCode)
        {
            if (string.IsNullOrEmpty(countryCode) || countryCode.Length != 2) return "🌐";
            try
            {
                int baseVal = 0x1F1E6 - 'A';
                return char.ConvertFromUtf32(baseVal + countryCode[0]) + char.ConvertFromUtf32(baseVal + countryCode[1]);
            }
            catch { return "🌐"; }
        }
    }

    // ── Domain Checker data model ───────────────────────────────────────────
    public class CheckerCategory
    {
        public string Name { get; }
        public (string Label, string Host)[] Entries { get; }
        public CheckerCategory(string name, (string, string)[] entries)
        {
            Name = name;
            Entries = entries;
        }
    }
}
