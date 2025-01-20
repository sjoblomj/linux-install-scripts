user_pref("accessibility.typeaheadfind.enablesound", false);
user_pref("accessibility.typeaheadfind.flashBar", 0);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", true);
user_pref("browser.download.useDownloadDir", false);
user_pref("browser.shell.checkDefaultBrowser", true);
user_pref("browser.startup.page", 3);
user_pref("browser.urlbar.placeholderName", "DuckDuckGo");
user_pref("browser.urlbar.placeholderName.private", "DuckDuckGo");
user_pref("findbar.highlightAll", true);
user_pref("general.autoScroll", true);


/* override recipe: enable location bar using search */
user_pref("keyword.enabled", true);


/* override recipe: enable session restore ***/
user_pref("browser.startup.page", 3); // 0102
  // user_pref("browser.privatebrowsing.autostart", false); // 0110 required if you had it set as true
  // user_pref("places.history.enabled", true); // 0862 required if you had it set as false
user_pref("browser.sessionstore.privacy_level", 0); // 1003 [to restore cookies/formdata if not sanitized]
  // user_pref("network.cookie.lifetimePolicy", 0); // 2801 [DON'T: add cookie + site data exceptions instead]
user_pref("privacy.clearOnShutdown.history", false); // 2811
  // user_pref("privacy.clearOnShutdown.cookies", false); // 2811 optional: default false arkenfox v94
  // user_pref("privacy.clearOnShutdown.formdata", false); // 2811 optional
user_pref("privacy.cpd.history", false); // 2812 to match when you use Ctrl-Shift-Del
  // user_pref("privacy.cpd.cookies", false); // 2812 optional: default false arkenfox v94
  // user_pref("privacy.cpd.formdata", false); // 2812 optional

/* override recipe: Automatic search from urlbar*/
user_pref("browser.search.suggest.enabled", true);
user_pref("browser.urlbar.suggest.searches", true);

/* override-recipe: desktop: alter new window max sizes **/
user_pref("privacy.window.maxInnerWidth", 2048); // 4502 [default 1600 in user.js v95]
user_pref("privacy.window.maxInnerHeight", 1152);  // 4502 [default 900 in user.js v95]
