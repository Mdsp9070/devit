use Mix.Config

# Git Hooks
if Mix.env() == :dev do
  config :git_hooks,
    auto_install: true,
    verbose: true,
    hooks: [
      pre_commit: [
        tasks: [
          {:cmd, "mix format"},
          {:cmd, "mix compile --warning-as-errors"},
          {:cmd, "mix credo --strict"}
        ]
      ]
    ]
end
