# --
# Kernel/Language/de_DynamicFieldRemoteDB.pm - provides german language translation for DynamicFieldRemoteDB package
# Copyright (C) 2006-2016 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/changed by:
# * Mario(dot)Illinger(at)cape(dash)it(dot)de
# * Stefan(dot)Mehlig(at)cape(dash)it(dot)de
# * Anna(dot)Litvinova(at)cape(dash)it(dot)de
# --
# $Id: de_DynamicFieldRemoteDB.pm,v 1.13 2016/03/01 13:08:09 millinger Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::pt_BR_DynamicFieldRemoteDB;
use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;
    my $Lang = $Self->{Translation};
    return 0 if ref $Lang ne 'HASH';

    # possible charsets
    $Self->{Charset} = ['utf-8', ];

    # $$START$$

    # Options
    $Lang->{'Remote Database Table'}  = 'Tabela para Banco de Dados Remoto';

    # Descriptions...
    $Lang->{'Before starting to enter data, refresh the page. After inserting all the records, click on the save button.'}
        = 'Antes de iniciar a inserção de dados atualize a página. Ao inserir todos os registros clique no botão salvar.';

    return 0;

    # $$STOP$$
}
1;
