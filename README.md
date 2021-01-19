# Devit

![build](https://github.com/Mdsp9070/devit/workflows/build/badge.svg?branch=main)

> publish your markdown to dev.to, from cli

devit is commandline utility that lets you publish your markdown documents
without leaving your comfy terminal.

## Install

You ccould download the latest release at [Releases page](https://github.com/Mdsp9070/devit/releases)

or install the escript with `mix`

```sh
mix escript.install hex devit 
```

## Configure

devit requires dev.to API key to be able to publish your markdown.
You can generate API key from the dev.to [settings](https://dev.to/settings/account)
page.
Export this integration token by adding it to your `~/.bashrc`, `~/.zshrc` or
`~/.config/fish/config.fish` as follows

- bash and zsh

```sh
export DEVTO_API_KEY="api_key"
```

- fish

```fish
set DEVTO_API_KEY "api_key"
```

Now you are good to go...

## Publishing

For publishing, your markdown doc must have the following frontmatter:

```yaml
--- 
title: My Awesome Post
tags: some, tags, here
published: true | false
---
## markdown here
```

If your post contains images, host them somewhere public and then include them
in your document like so:

```markdown
![cat](https://catpics.com/some_cat.png)
```

Dev.to will then CDN it and you can delete it from there if you want to.

When you’re ready to publish, run

```console
$ devit -a <path-to-article> 
Done! Your post has been published at https://medium.com/@gaben/76272e9d241c
```

It’s that simple.

## Uninstall

It's sad to see you go :(

Only remove the downloaded binary

or

```
mix escript.uninstall devit
```

## Inspiration

This project is completely based on [mdm](https://github.com/pavanjadhaw/mdm)!
Ireally like of the ideai and tried to implement in Elixir and also give
a try on dev.to API!

## License

MIT © Matheus Pessanha <mdsp@boosting.tech>
