package com.netwatch.app;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class CsvUtilTest {

    @Test public void wrapsPlainValueInQuotes() {
        assertEquals("\"example.com\"", CsvUtil.escape("example.com"));
    }

    @Test public void doublesEmbeddedQuotes() {
        assertEquals("\"say \"\"hi\"\"\"", CsvUtil.escape("say \"hi\""));
    }

    @Test public void nullBecomesEmptyQuotedField() {
        assertEquals("\"\"", CsvUtil.escape(null));
    }

    @Test public void preservesCommasAndNewlinesInsideQuotes() {
        assertEquals("\"a,b\nc\"", CsvUtil.escape("a,b\nc"));
    }
}
