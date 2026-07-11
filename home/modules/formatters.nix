{
  ...
}:

{
  editorconfig = {
    enable = true;

    settings = {
      "*" = {
        indent_style = "space";
        indent_size = "3";
        trim_trailing_whitespace = "true";
        insert_final_newline = "true";
      };

      "*.lua" = {
        # continuation_indent.before_block = 4
        # continuation_indent.in_expr = 4
        # continuation_indent.in_table = 4
        continuation_indent = "3";
        max_line_length = "120";
        end_of_line = "unset";
        table_separator_style = "comma";
        trailing_table_separator = "smart";
        call_arg_parentheses = "always";
        detect_end_of_line = "false";
        space_around_table_field_list = "true";
        space_before_attribute = "true";
        space_before_function_open_parenthesis = "false";
        space_before_function_call_open_parenthesis = "false";
        space_before_closure_open_parenthesis = "false";
        space_before_function_call_single_arg = "true";
        space_before_open_square_bracket = "false";
        space_inside_function_call_parentheses = "true";
        space_inside_function_param_list_parentheses = "true";
        space_inside_square_brackets = "false";
        space_around_table_append_operator = "false";
        ignore_spaces_inside_function_call = "false";
        space_before_inline_comment = "1";
        space_after_comment_dash = "true";
        space_around_math_operator = "true";
        space_after_comma = "true";
        space_after_comma_in_for_statement = "true";
        space_around_concat_operator = "true";
        space_around_logical_operator = "true";
        space_around_assign_operator = "true";
        align_call_args = "true";
        align_function_params = "true";
        align_continuous_assign_statement = "true";
        align_continuous_rect_table_field = "true";
        align_if_branch = "false";
        align_array_table = "true";
        align_continuous_similar_call_args = "true";
        align_continuous_inline_comment = "true";
        align_chain_expr = "always";
        never_indent_before_if_condition = "false";
        never_indent_comment_on_if_branch = "false";
        keep_indents_on_empty_lines = "false";
        allow_non_indented_comments = "false";
        line_space_after_if_statement = "max(2)";
        line_space_after_do_statement = "fixed(10)";
        line_space_after_while_statement = "fixed(10)";
        line_space_after_repeat_statement = "fixed(10)";
        line_space_after_for_statement = "max(2)";
        line_space_after_local_or_assign_statement = "max(2)";
        line_space_after_function_statement = "fixed(10)";
        line_space_after_expression_statement = "max(3)";
        line_space_after_comment = "max(2)";
        line_space_around_block = "fixed(1)";
        break_all_list_when_line_exceed = "true";
        auto_collapse_lines = "false";
        break_before_braces = "false";
        ignore_space_after_colon = "false";
        remove_call_expression_list_finish_comma = "false";
        end_statement_with_semicolon = "always";
        quote_style = "double";
      };
    };
  };

  home.file.".prettierrc.json".text = builtins.toJSON {
    "arrowParens" = "always";
    "bracketSpacing" = true;
    "htmlWhitespaceSensitivity" = "css";
    "insertPragma" = false;
    "jsxBracketSameLine" = false;
    "jsxSingleQuote" = false;
    "printWidth" = 80;
    "proseWrap" = "always";
    "quoteProps" = "as-needed";
    "requirePragma" = false;
    "semi" = true;
    "singleQuote" = false;
    "tabWidth" = 3;
    "trailingComma" = "all";
    "useTabs" = false;
  };

  home.file.".clang_format".text = ''
    BasedOnStyle: LLVM
    AccessModifierOffset: -1
    AlignAfterOpenBracket: true
    AlignArrayOfStructures: Right
    AlignConsecutiveAssignments:
      Enabled: true
      AcrossEmptyLines: false
      AcrossComments: false
      AlignCompound: true
      AlignFunctionPointers: false
      PadOperators: false
    AlignConsecutiveBitFields:
      Enabled: true
      AcrossEmptyLines: false
      AcrossComments: false
      AlignCompound: true
      AlignFunctionPointers: false
      PadOperators: false
    AlignConsecutiveDeclarations:
      Enabled: true
      AcrossEmptyLines: false
      AcrossComments: false
      AlignCompound: true
      AlignFunctionPointers: false
      PadOperators: false
    AlignConsecutiveMacros:
      Enabled: true
      AcrossEmptyLines: false
      AcrossComments: false
      AlignCompound: true
      AlignFunctionPointers: false
      PadOperators: false
    AlignConsecutiveShortCaseStatements:
      Enabled: true
      AcrossEmptyLines: false
      AcrossComments: false
      AlignCaseArrows: true
      AlignCaseColons: false
    AlignConsecutiveTableGenBreakingDAGArgColons:
      Enabled: true
      AcrossEmptyLines: false
      AcrossComments: false
      AlignCompound: true
      AlignFunctionPointers: false
      PadOperators: false
    AlignConsecutiveTableGenCondOperatorColons:
      Enabled: true
      AcrossEmptyLines: false
      AcrossComments: false
      AlignCompound: true
      AlignFunctionPointers: false
      PadOperators: false
    AlignConsecutiveTableGenDefinitionColons:
      Enabled: true
      AcrossEmptyLines: false
      AcrossComments: false
      AlignCompound: true
      AlignFunctionPointers: false
      PadOperators: false
    AlignEscapedNewlines: LeftWithLastLine
    AlignOperands: Align
    AlignTrailingComments:
      Kind: Always
      OverEmptyLines: 1
    AllowAllArgumentsOnNextLine: false
    AllowAllParametersOfDeclarationOnNextLine: false
    AllowBreakBeforeNoexceptSpecifier: Never
    AllowShortBlocksOnASingleLine: Never
    AllowShortCaseExpressionOnASingleLine: false
    AllowShortCaseLabelsOnASingleLine: false
    AllowShortCompoundRequirementOnASingleLine: true
    AllowShortEnumsOnASingleLine: false
    AllowShortFunctionsOnASingleLine: None
    AllowShortIfStatementsOnASingleLine: Never
    AllowShortLambdasOnASingleLine: Empty
    AllowShortLoopsOnASingleLine: false
    AlwaysBreakBeforeMultilineStrings: false
    AttributeMacros:
      - __capability
    BinPackArguments: false
    BinPackParameters: OnePerLine
    BitFieldColonSpacing: Both
    BraceWrapping:
      AfterCaseLabel: false
      AfterClass: true
      AfterControlStatement: Never
      AfterEnum: false
      AfterFunction: true
      AfterNamespace: false
      AfterObjCDeclaration: false
      AfterStruct: false
      AfterUnion: false
      AfterExternBlock: false
      BeforeCatch: false
      BeforeElse: false
      BeforeLambdaBody: false
      BeforeWhile: false
      IndentBraces: false
      SplitEmptyFunction: true
      SplitEmptyRecord: true
      SplitEmptyNamespace: true
    BreakAdjacentStringLiterals: true
    BreakAfterAttributes: Leave
    BreakAfterJavaFieldAnnotations: false
    BreakArrays: false
    BreakBeforeBinaryOperators: None
    BreakBeforeBraces: Custom
    BreakBeforeConceptDeclarations: Never
    BreakBeforeInlineASMColon: OnlyMultiline
    BreakBeforeTernaryOperators: true
    BreakBinaryOperations: RespectPrecedence
    BreakConstructorInitializers: AfterColon
    BreakFunctionDefinitionParameters: false
    BreakInheritanceList: AfterColon
    BreakStringLiterals: true
    BreakTemplateDeclarations: No
    ColumnLimit: 80
    CommentPragmas: "^ IWYU pragma:"
    CompactNamespaces: false
    ConstructorInitializerIndentWidth: 3
    ContinuationIndentWidth: 3
    Cpp11BracedListStyle: false
    DerivePointerAlignment: false
    DisableFormat: false
    EmptyLineAfterAccessModifier: Never
    EmptyLineBeforeAccessModifier: Always
    ExperimentalAutoDetectBinPacking: false
    FixNamespaceComments: true
    ForEachMacros:
      - foreach
      - Q_FOREACH
      - BOOST_FOREACH
    IfMacros:
      - KJ_IF_MAYBE
    IncludeBlocks: Regroup
    IncludeCategories:
      - Regex: ^"(llvm|llvm-c|clang|clang-c)/
        Priority: 2
        SortPriority: 0
        CaseSensitive: true
      - Regex: ^(<|"(gtest|gmock|isl|json)/)
        Priority: 3
        SortPriority: 0
        CaseSensitive: true
      - Regex: .*
        Priority: 1
        SortPriority: 0
        CaseSensitive: true
    IncludeIsMainRegex: (Test)?$
    IncludeIsMainSourceRegex: ""
    IndentAccessModifiers: false
    IndentCaseBlocks: false
    IndentCaseLabels: true
    IndentExternBlock: Indent
    IndentGotoLabels: true
    IndentPPDirectives: AfterHash
    IndentRequiresClause: true
    IndentWidth: 3
    IndentWrappedFunctionNames: false
    InsertBraces: true
    InsertNewlineAtEOF: true
    InsertTrailingCommas: None
    IntegerLiteralSeparator:
      Binary: 0
      BinaryMinDigits: 0
      Decimal: 0
      DecimalMinDigits: 0
      Hex: 0
      HexMinDigits: 0
    JavaScriptQuotes: Leave
    JavaScriptWrapImports: true
    KeepEmptyLines:
      AtEndOfFile: false
      AtStartOfBlock: false
      AtStartOfFile: false
    LambdaBodyIndentation: Signature
    LineEnding: DeriveLF
    MacroBlockBegin: ""
    MacroBlockEnd: ""
    MainIncludeChar: Quote
    MaxEmptyLinesToKeep: 1
    NamespaceIndentation: All
    ObjCBinPackProtocolList: Auto
    ObjCBlockIndentWidth: 3
    ObjCBreakBeforeNestedBlockParam: true
    ObjCSpaceAfterProperty: false
    ObjCSpaceBeforeProtocolList: true
    PPIndentWidth: -1
    PackConstructorInitializers: BinPack
    PenaltyBreakAssignment: 2
    PenaltyBreakBeforeFirstCallParameter: 19
    PenaltyBreakComment: 300
    PenaltyBreakFirstLessLess: 120
    PenaltyBreakOpenParenthesis: 0
    PenaltyBreakScopeResolution: 500
    PenaltyBreakString: 1000
    PenaltyBreakTemplateDeclaration: 10
    PenaltyExcessCharacter: 1000000
    PenaltyIndentedWhitespace: 0
    PenaltyReturnTypeOnItsOwnLine: 60
    PointerAlignment: Right
    QualifierAlignment: Leave
    ReferenceAlignment: Pointer
    ReflowComments: true
    RemoveBracesLLVM: false
    RemoveEmptyLinesInUnwrappedLines: true
    RemoveParentheses: MultipleParentheses
    RemoveSemicolon: false
    RequiresClausePosition: WithPreceding
    RequiresExpressionIndentation: OuterScope
    SeparateDefinitionBlocks: Always
    ShortNamespaceLines: 0
    SkipMacroDefinitionBody: false
    SortIncludes: CaseSensitive
    SortJavaStaticImport: Before
    SortUsingDeclarations: LexicographicNumeric
    SpaceAfterCStyleCast: false
    SpaceAfterLogicalNot: false
    SpaceAfterTemplateKeyword: true
    SpaceAroundPointerQualifiers: Default
    SpaceBeforeAssignmentOperators: true
    SpaceBeforeCaseColon: false
    SpaceBeforeCpp11BracedList: false
    SpaceBeforeCtorInitializerColon: true
    SpaceBeforeInheritanceColon: true
    SpaceBeforeJsonColon: false
    SpaceBeforeParensOptions:
      AfterControlStatements: true
      AfterForeachMacros: true
      AfterFunctionDeclarationName: false
      AfterFunctionDefinitionName: false
      AfterIfMacros: true
      AfterOverloadedOperator: false
      AfterPlacementOperator: true
      AfterRequiresInClause: false
      AfterRequiresInExpression: false
      BeforeNonEmptyParentheses: false
    SpaceBeforeRangeBasedForLoopColon: true
    SpaceBeforeSquareBrackets: false
    SpaceInEmptyBlock: false
    SpacesBeforeTrailingComments: 1
    SpacesInAngles: Never
    SpacesInContainerLiterals: true
    SpacesInLineCommentPrefix:
      Minimum: 1
      Maximum: -1
    SpacesInParens: Custom
    SpacesInParensOptions:
      ExceptDoubleParentheses: false
      InConditionalStatements: true
      InCStyleCasts: false
      InEmptyParentheses: false
      Other: false
    SpacesInSquareBrackets: false
    Standard: Latest
    StatementAttributeLikeMacros:
      - Q_EMIT
    StatementMacros:
      - Q_UNUSED
      - QT_REQUIRE_VERSION
    TabWidth: 3
    TableGenBreakInsideDAGArg: BreakElements
    UseTab: Never
    VerilogBreakBetweenInstancePorts: true
    WhitespaceSensitiveMacros:
      - BOOST_PP_STRINGIZE
      - CF_SWIFT_NAME
      - NS_SWIFT_NAME
      - PP_STRINGIZE
      - STRINGIZE
  '';
}
