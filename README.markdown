# TITokenFieldView
### A control which mimics the To: field in Mail and Messages. Kinda like an NSTokenField.

## Why Fork

This fork is based on https://github.com/enriquez/TITokenFieldView

### Changes

- Converted to ARC

- More delegate methods:
```objective-c
  - (NSArray *)tokenField:(TITokenField *)tokenField resultsForSearchPattern:(NSString *)pattern;
  - (NSString *)tokenField:(TITokenField *)tokenField willCreateTokenWithTitle:(NSString *)title;
  - (void)tokenField:(TITokenField *)tokenField willAddToken:(TIToken *)token withTitle:(NSString *)title;
  - (void)tokenField:(TITokenField *)tokenField didAddToken:(TIToken *)token;
  - (void)tokenField:(TITokenField *)tokenField didRemoveToken:(TIToken *)token;
```
- Allows search on background

- Possibility to have search results table hidden upon user selecting a suggestion (hideResultsTableOnSelection property)

- Updated example project to take advantage of all changes

## Usage

See the "TokenFieldExample" app for details on usage. It's limited at the moment to one tokenising field and a content view below because it's pulled straight from one of my apps. Multiple field support requires tweaking.

If you're using an external picker, like the contacts picker included with iOS, make sure you call dismissModalViewController:before calling addToken on the field, otherwise existing tokens will be lost.

## License

This control is dual licensed:
You can use it for free under the BSD licence below or, 
If you require non-attribution you can purchase the commercial licence available at http://www.cocoacontrols.com/authors/thermogl

Copyright (c) 2012 - 2013 Tom Irving. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY TOM IRVING "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL TOM IRVING OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
