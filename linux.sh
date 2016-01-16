#!/bin/sh
FILES="*.cgi"
TGDIR="./distrib/libraries"
DISTR="./distrib"
mkdir -p $TGDIR
cp -R images $TGDIR
cp -R lang $TGDIR
cp -R lib $TGDIR
cp -R unauthenticated $TGDIR

cp config $TGDIR
cp libraries-lib.pl $TGDIR
cp LICENCE $TGDIR
cp module.info $TGDIR
cp config.info $TGDIR
cp README.md $TGDIR

for f in $FILES
do
  if [ -f $f -a -r $f ]; then
   cp $f "$TGDIR/$f"
  else
   echo "Error: Cannot read $f"
  fi
done

cd distrib
tar -zcf libraries-0.1.0.linux.wbm.gz libraries
cd ../
rm -rf $TGDIR
