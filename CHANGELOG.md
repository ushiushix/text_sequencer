# CHANGELOG
## 2022-11-03
* Add pb and pbx command
    * pbx XX YY: Set pitch bend value to XX (-8192 to 8191) with step time YY
    * pb XX YY: Set pitch bend value to XX(-64 to 63) * 64, with step time YY. User-friendly version

## 2017-12-03
* Bump version to 1.0.0
* Reformat this changelog to MD
	
## 2015-09-06  Koichi INOUE  <inoue@windy.local>

* Add 'shift' command.  It defines the offset to the note digit. Default is 0.

## 2015-08-11  Koichi INOUE  <inoue@windy.local>

* Default value is changed when st and/or gt is omited.
* If gt is omited, it is taken from gate value. If gate value is 0, it inherits st for the note. By default gate value is initialized as 0.
* If gt is omited and st is 0, gt is taken from step value.
* If st is omited, st is taken from step value.

## 2015-08-01  Koichi INOUE  <inoue@windy.local>

* Add `step` and `gate` command to set default ST and GT respectively.
* Raise error on unclosed parentheses at the end of input.
* ST and GT was reversed when the note was written in digit.

## 2015-07-31  Koichi INOUE  <inoue@windy.local>

* Exchange 2nd and 3rd colum in text notation. The order is now step time and gate time, which is generally accepted.

## 2015-07-19  Koichi INOUE  <inoue@windy.local>

* Add macro feature.

## 2015-07-19  Koichi INOUE  <inoue@windy.local>

* Rename midilib.rb to midilib_exporter.rb to match the class name.

## 2014-08-10  Koichi INOUE  <inoue@windy>

* Fix calculation of note timing when length and delay is specified.

## 2014-07-30  Koichi INOUE  <inoue@windy>

* Version 0.1.1
* Support writing a note as a note number.

## 2014-07-27  Koichi INOUE  <ushiushix@gmail.com>

* Version 0.1.0
* Now depends on ruby 2.0.0 or later.
* TextSequencer::Sequencer is the entry point instead of TextSequencer::Parser.

## 2012-08-19  Koichi INOUE  <ushiushix@gmail.com>

* Initial release
