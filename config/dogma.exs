use Mix.Config
alias Dogma.Rule

config :dogma,

  rule_set: Dogma.RuleSet.All,

  override: [
    %Rule.LineLength{ enabled: false },
    %Rule.MultipleBlankLines{ max_lines: 1 },
    %Rule.InfixOperatorPadding{ fn_arrow_padding: true },
    %Rule.FunctionArity{ max: 5 },
    %Rule.TakenName{ enabled: false },
    %Rule.NegatedIfUnless{ enabled: false }
  ]
