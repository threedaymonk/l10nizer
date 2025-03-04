L10nizer
========

Automatic _ex post facto_ localisation for Rails templates.

What it does
------------

Processes all your `html.erb` templates, extracts text, replaces it with `t()`
calls, and generates a YAML file of localisations.

For example, given a file `app/views/things/show.html.erb` with this content:

```erb
<div class="thing">
  <h1>Some heading</h1>
  <p>This thing is called <%= @thing.name %></p>
</div>
```

l10nizer will change it to:

```erb
<div class="thing">
  <h1><%= t(".some_heading") %></h1>
  <p><%= t(".this_thing_is_called_a", a: @thing.name) %></p>
</div>
```

and generate the following entries in `config/locales/l10nized.yml`:

```yaml
things:
  show:
    some_heading: Some heading
    this_thing_is_called_a: This thing is called %{a}
```

You can then use `l10nized.yml` as a basis for the localisation file for your
current locale, e.g. `en_GB.yml`.

Usage
-----

To extract strings from templates:

```sh
$ l10nizer --extract /path/to/my/rails/app
```

To check that there are no unlocalised strings (e.g. as part of a build
process):

```sh
$ l10nizer /path/to/my/rails/app
```

The path defaults to the current working directory.

Limitations
-----------

* Perhaps ironically for a _localisation_ utility, l10nizer assumes that your
  templates are written in English or generally in ASCII, and ignores
  non-alphanumeric content when generating localisation keys. This could be
  fixed by modifying or replacing the L10nizer::KeyGenerator class.
* L10nizer takes no position on HTML entities or escaping. You __will__ need to
  review the changes it makes.
* Similarly, pluralisation is outside the scope of this application and will
  require attention.
* Strings that should be single entities but which contain HTML will be broken
  into multiple localisation strings.
