#!/usr/bin/perl -w

use t::lib::XSP::Test;

run_diff xsp_stdout => 'expected';

__DATA__

=== Basic plugin functionality
--- xsp_stdout
%module{XspTest};
%package{Foo};
%loadplugin{t::lib::XSP::Plugin};
%loadplugin{t::lib::XSP::Plugin};

int foo(int y);

class Y
{
    void bar();
};
--- expected
# XSP preamble


MODULE=XspTest

MODULE=XspTest PACKAGE=Foo

int
foo_perl( int y )
  CODE:
    try {
      RETVAL = foo( y );
    }
    catch (std::exception& e) {
      croak("Caught C++ exception of type or derived from 'std::exception': %s", e.what());
    }
    catch (...) {
      croak("Caught C++ exception of unknown type");
    }
  OUTPUT: RETVAL


MODULE=XspTest PACKAGE=Y

void
Y::bar()
  CODE:
    try {
      THIS->bar();
    }
    catch (std::exception& e) {
      croak("Caught C++ exception of type or derived from 'std::exception': %s", e.what());
    }
    catch (...) {
      croak("Caught C++ exception of unknown type");
    }

=== Plugin loading from the plugin namespace
--- xsp_stdout
%module{XspTest};
%package{Foo};
%loadplugin{TestPlugin};

int foo(int y);

class Y
{
    void bar();
};
--- expected
# XSP preamble


MODULE=XspTest

MODULE=XspTest PACKAGE=Foo

int
foo_perl2( int y )
  CODE:
    try {
      RETVAL = foo( y );
    }
    catch (std::exception& e) {
      croak("Caught C++ exception of type or derived from 'std::exception': %s", e.what());
    }
    catch (...) {
      croak("Caught C++ exception of unknown type");
    }
  OUTPUT: RETVAL


MODULE=XspTest PACKAGE=Y

void
Y::bar()
  CODE:
    try {
      THIS->bar();
    }
    catch (std::exception& e) {
      croak("Caught C++ exception of type or derived from 'std::exception': %s", e.what());
    }
    catch (...) {
      croak("Caught C++ exception of unknown type");
    }
