== Unobtrusive

This is a simple file-copying plugin to ease the process of using specific Javascript libraries in your Rails application.

It includes the LowPro library by Dan Webb, some of his behaviors, the latest version of prototype.js, and a sample unobtrusive.js for you to edit.

The unobtrusive.js file is yours to edit (or rename). You'll also need to include these files in the HTML templates in which you want to use them.

== Usage

  ./script/plugin install git://github.com/dwg/unobtrusive.git

  ./script/generate unobtrusive
  
  <%= javascript_include_tag :unobtrusive %>

== Author

Geoffrey Grosenbach http://peepcode.com

== Contributors

Arni Einarsson
