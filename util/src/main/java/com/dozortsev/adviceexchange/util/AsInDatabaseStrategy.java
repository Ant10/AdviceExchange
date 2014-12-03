package com.dozortsev.adviceexchange.util;

import org.jooq.util.DefaultGeneratorStrategy;
import org.jooq.util.Definition;
import org.jooq.util.mysql.MySQLTableDefinition;

import static java.util.Arrays.asList;
import static org.jooq.util.GeneratorStrategy.Mode.DEFAULT;
import static org.jooq.util.GeneratorStrategy.Mode.POJO;

public class AsInDatabaseStrategy extends DefaultGeneratorStrategy {

    @Override
    public String getJavaClassExtends(Definition definition, Mode mode) {
        if (POJO.equals(mode)) {
            if (asList("answer", "question", "comment").contains(definition.getName())) {
                return "UserActivity";
            }
        }
        return Object.class.getName();
    }

    @Override
    public String getJavaClassName(Definition definition, Mode mode) {
        String name = super.getJavaClassName(definition, mode);

        return DEFAULT.equals(mode) && definition.getClass().equals(MySQLTableDefinition.class)
                ? "T" + name
                : name;
    }
}