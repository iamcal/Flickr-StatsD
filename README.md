# The Original StatsD

This is the original (2008) version of StatsD. **Do not use it in production**.
It is presented here as a piece of history, rather than useful working code.
The original Flickr public SVN repo disappeared in 2010, so this is as close
to an 'official' mirror as you'll find.

Due to the way the collection rollup works, via alarms, the daemon chews up way
more CPU than it should. It's also written in Perl. From the past.


## Timeline

* August 2008: I wrote the original version of StatsD at Flickr, in Perl.

* October 2008: I talked about the Perl version in a Flickr Code Blog article called
  <a href="http://code.flickr.net/2008/10/27/counting-timing/">Counting & Timing</a>.
  At the time, it attracted some attention and while a few people talked about it,
  nobody actually used it, as far as I can tell (besides Flickr, of course).

* February 2010: Coda Hale at Yammer released <a href="http://metrics.codahale.com/">Metrics</a>,
  which would later influence some StatsD design.

* August 2010: I re-implemented StatsD in node.js for <a href="http://www.glitch.com/">Glitch</a>.
  It's on GitHub as <a href="https://github.com/iamcal/rollup/">rollup</a>.

* December 2010: Erik Kastner at Etsy started working on a node.js implementation
  of StatsD, to get around the terrible performance of my Perl version. You should
  <a href="https://github.com/etsy/statsd/">use their version</a>.

* February 2011: Ian Malpass at Etsy wrote about their StatsD version in a
  Code as Craft blog post called
  <a href="http://codeascraft.etsy.com/2011/02/15/measure-anything-measure-everything/">Measure
  Anything, Measure Everything</a>. Everybody on the Internet read it and now the Etsy StatsD
  project has 4000 stars, 600 forks and more than 100 committers.

A post-facto spec for the StatsD wire protocol has been <a href="https://github.com/b/statsd_spec">gathered here</a>.
