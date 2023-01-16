# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2003 Gilberto Cezar de Almeida <gibalmeida at hotmail.com>
# Copyright (C) 2005 Alterado por Glaucia C. Messina (glauglauu@yahoo.com)
# Copyright (C) 2007-2010 Fabricio Luiz Machado <soprobr gmail.com>
# Copyright (C) 2010-2011 Murilo Moreira de Oliveira <murilo.moreira 60kg gmail.com>
# Copyright (C) 2013 Alexandre <matrixworkstation@gmail.com>
# Copyright (C) 2013-2014 Murilo Moreira de Oliveira <murilo.moreira 60kg gmail.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
#Kernel/Language/pt_BR_RESTAPIAuth.pm
# --
package Kernel::Language::pt_BR_RESTAPIAuth;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';
    $Self->{Completeness}        = 0.938367761598375;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = '.';
    $Self->{Translation} = {

        # 
        'Doctor' => 'Médico',
        'Academic' => 'Acadêmico',
        'Collaborator' => 'Colaborador',
        'Type access' => 'Tipo de acesso',
    };

    $Self->{JavaScriptStrings} = [
        
    ];

    # $$STOP$$
    return;
}

1;
