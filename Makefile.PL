use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Tie::Handle::CSV',
    AUTHOR              => 'Daniel B. Boorstein <danboo@cpan.org>',
    VERSION_FROM        => 'lib/Tie/Handle/CSV.pm',
    ABSTRACT_FROM       => 'lib/Tie/Handle/CSV.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Text::CSV_XS' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Tie-Handle-CSV-*' },
);
