# OpenAPI Java Generator Complex Defaults Bug
https://github.com/OpenAPITools/openapi-generator/issues/21051

This generates a Java client for the OpenAPI spec in `openapi.yaml` using the OpenAPI Generator. The 
generated code has a bug where the default value for a complex object is not set correctly.

The issue occurs because of the default values assigned for properties, https://github.com/OpenAPITools/openapi-generator/blob/v7.12.0/modules/openapi-generator/src/main/resources/Java/pojo.mustache#L72-L87

## Issue
When using complex objects as default values in the OpenAPI spec, the generated Java code fails to compile. The error 
occurs because the generated code tries to initialize complex objects with an invalid syntax.

The following is **valid** OpenAPI - using a complex default:
```yaml
components:
  schemas:
    Test:
      type: object
      properties:
        testEmptyInlineObject:
          type: object
          default: {}
```

The generated Java code for this OpenAPI spec will look like this, which is invalid Java:
```java
private Object testEmptyInlineObject = {};
```

This extends to all complex objects, including references to other schemas.

## Steps to Reproduce
1. Clone the repository.
2. Run the following command to generate the Java client:
   ```bash
   make .generated
   ```

## Output of Java Compile
```
> Task :compileJava FAILED
warning: [options] source value 8 is obsolete and will be removed in a future release
warning: [options] target value 8 is obsolete and will be removed in a future release
warning: [options] To suppress warnings about obsolete options, use -Xlint:-options.
/bug_java_generator/.generated/src/main/java/org/openapitools/client/model/Test.java:60: error: illegal initializer for Object
  private Object testEmptyInlineObject = {};
                                         ^
/bug_java_generator/.generated/src/main/java/org/openapitools/client/model/Test.java:65: error: illegal initializer for TestTestComplexInlineObject
  private TestTestComplexInlineObject testComplexInlineObject = {foo=bar};
                                                                ^
/bug_java_generator/.generated/src/main/java/org/openapitools/client/model/Test.java:65: error: cannot find symbol
  private TestTestComplexInlineObject testComplexInlineObject = {foo=bar};
                                                                 ^
  symbol:   variable foo
  location: class Test
/bug_java_generator/.generated/src/main/java/org/openapitools/client/model/Test.java:65: error: cannot find symbol
  private TestTestComplexInlineObject testComplexInlineObject = {foo=bar};
                                                                     ^
  symbol:   variable bar
  location: class Test
/bug_java_generator/.generated/src/main/java/org/openapitools/client/model/Test.java:70: error: illegal initializer for Object
  private Object testNullableEmptyInlineObject = {};
                                                 ^
/bug_java_generator/.generated/src/main/java/org/openapitools/client/model/Test.java:75: error: illegal initializer for TestTestNullableComplexInlineObject
  private TestTestNullableComplexInlineObject testNullableComplexInlineObject = {foo=bar};
                                                                                ^
/bug_java_generator/.generated/src/main/java/org/openapitools/client/model/Test.java:75: error: cannot find symbol
  private TestTestNullableComplexInlineObject testNullableComplexInlineObject = {foo=bar};
                                                                                 ^
  symbol:   variable foo
  location: class Test
/bug_java_generator/.generated/src/main/java/org/openapitools/client/model/Test.java:75: error: cannot find symbol
  private TestTestNullableComplexInlineObject testNullableComplexInlineObject = {foo=bar};
                                                                                     ^
  symbol:   variable bar
  location: class Test
/bug_java_generator/.generated/src/main/java/org/openapitools/client/model/Test.java:80: error: illegal initializer for Object
  private Object testEmptyReference = {};
                                      ^
/bug_java_generator/.generated/src/main/java/org/openapitools/client/model/Test.java:85: error: illegal initializer for ComplexReferenceObject
  private ComplexReferenceObject testComplexReference = {foo=bar};
                                                        ^
/bug_java_generator/.generated/src/main/java/org/openapitools/client/model/Test.java:85: error: cannot find symbol
  private ComplexReferenceObject testComplexReference = {foo=bar};
                                                         ^
  symbol:   variable foo
  location: class Test
/bug_java_generator/.generated/src/main/java/org/openapitools/client/model/Test.java:85: error: cannot find symbol
  private ComplexReferenceObject testComplexReference = {foo=bar};
                                                             ^
  symbol:   variable bar
  location: class Test
/bug_java_generator/.generated/src/main/java/org/openapitools/client/model/Test.java:90: error: illegal initializer for Object
  private Object testNullableEmptyReference = {};
                                              ^
/bug_java_generator/.generated/src/main/java/org/openapitools/client/model/Test.java:95: error: illegal initializer for NullableComplexReferenceObject
  private NullableComplexReferenceObject testNullableComplexReference = {foo=bar};
                                                                        ^
/bug_java_generator/.generated/src/main/java/org/openapitools/client/model/Test.java:95: error: cannot find symbol
  private NullableComplexReferenceObject testNullableComplexReference = {foo=bar};
                                                                         ^
  symbol:   variable foo
  location: class Test
/bug_java_generator/.generated/src/main/java/org/openapitools/client/model/Test.java:95: error: cannot find symbol
  private NullableComplexReferenceObject testNullableComplexReference = {foo=bar};
                                                                             ^
  symbol:   variable bar
  location: class Test
16 errors
3 warnings

FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':compileJava'.
> Compilation failed; see the compiler error output for details.

* Try:
> Run with --info option to get more log output.
> Run with --scan to get full insights.

Deprecated Gradle features were used in this build, making it incompatible with Gradle 9.0.

You can use '--warning-mode all' to show the individual deprecation warnings and determine if they come from your own scripts or plugins.

For more on this, please refer to https://docs.gradle.org/8.7/userguide/command_line_interface.html#sec:command_line_warnings in the Gradle documentation.

BUILD FAILED in 6s
1 actionable task: 1 executed
make: *** [Makefile:6: .generated] Error 1
```
