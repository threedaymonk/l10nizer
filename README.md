L10nizer
========

Automagic _ex post facto_ localisation for Rails templates.

What it does
------------

Processes all your `html.erb` templates, extracts text, replaces it with `t()` calls, and generates a YAML file of localisations.

For example, given a file `app/views/things/show.html.erb` with this content:

    <div class="thing">
      <h1>Some heading</h1>
      <p>This thing is called <%= h(@thing.name)</p>
    </div>

l10nizer will change it to:

    <div class="thing">
      <h1><%= t("things.some_heading") %></h1>
      <p><%= t("things.this_thing_is_called_a", :a => h(@thing.name)) %></p>
    </div>

and generate the following entries in `config/locales/l10nized.yml`:

    things:
      some_heading: Some heading
      this_thing_is_called_a: This thing is called {{a}}

You can then make `l10nized.yml` the localisation file for your current locale, e.g. `en_GB.yml`.

Usage
-----

From within a Rails application directory:

    l10nizer

Specifying the application path explicitly:

    l10nizer /path/to/my/rails/app

Limitations
-----------

* Perhaps ironically for a _localisation_ utility, l10nizer assumes that your templates are written in English or generally in ASCII, and ignores non-alphanumeric content when generating localisation keys. This could be fixed by modifying or replacing the L10nizer::KeyGenerator class.
* L10nizer takes no position on HTML entities or escaping. You __will__ need to review the changes it makes.
* Similarly, pluralisation is outside the scope of this application and will require attention.
* Strings that should be single entities but which contain HTML will be broken into multiple localisation strings.
