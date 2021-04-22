// --
// Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

var app = angular.module('ocsIntegration',[]);
app.controller('configuration', function ($scope, $http) {
    $scope.snmp = {
        OtrsClass: '',
        SnmpData: []
    };

    $scope.snmpClasses = [];

    $scope.computer = {
        OtrsClass: 'SNMP',
        ComputerData: []
    };   

    
    if($('#hdnType').val()==="Snmp"){
        $scope.loading = true;
        
        $http.get($('#hdnLoadUrl').val())
            .then(function(response){
                $scope.snmp = response.data.data;
                $scope.closeAllSnmp($scope.snmp.SnmpData);
                $http.get($('#hdnLoadClassesUrl').val())
                    .then(function(response){
                        $scope.loading = false;
                        for(var i = 0; i < response.data.data.length;i++){
                            $scope.loading = true;
                            $http.get($('#hdnLoadUrl').val()+';ClassId='+response.data.data[i].ID)

                                .then(function(response2){        
                                    $scope.snmpClasses.push(response2.data.data);
                                    for(var u = 0; u < $scope.snmpClasses.length;u++){
                                        $scope.closeAllSnmp($scope.snmpClasses[u].SnmpData);
                                    }
                                    
                                    console.log("classe",$scope.snmpClasses);
                                    $scope.loading = false;
                                });
                        }                        
                    });
            });
    }
    else if ($('#hdnType').val()==="Computer"){
        $scope.loading = true;
        
        $http.get($('#hdnLoadUrl').val())
            .then(function(response){
                $scope.computer = response.data.data;
                $scope.closeAllSnmp($scope.computer.ComputerData);
                console.log("computers",response);
                $scope.loading = false;
            });
    }

    $scope.updateSnmp = function(event,snmp){
        if(confirm("Esta opção pode demorar um pouco para ser executada pois consiste em analisar todo o conteúdo do OCS para definir todos os itens da estrutura que podem ser utilizados. Deseja continuar?")){
            $scope.loading = true;
            $http.get(event)
            .then(function(response){
                snmp.SnmpData = response.data.data;
                $scope.loading = false;
            });
        }
    };

    $scope.updateComputer = function(event){
        if(confirm("Esta opção pode demorar um pouco para ser executada pois consiste em analisar todo o conteúdo do OCS para definir todos os itens da estrutura que podem ser utilizados. Deseja continuar?")){
            console.log("Iniciando");
            $scope.loading = true;
            $http.get(event)
            .then(function(response){
                $scope.computer.ComputerData = response.data.data;
                $scope.loading = false;
                console.log("Finalizando");
            });
        }
    };

    $scope.closeSnmp = function(id,snmpData){
        for(var i = 0; i< snmpData.length;i++){
            if(snmpData[i].ID == id){
                snmpData[i].closed = true;                   
            }
            if(snmpData[i].ParentId == id){
                snmpData[i].close = true;
                $scope.closeSnmp(snmpData[i].ID,snmpData);                    
            }
        }
    };

    $scope.closeAllSnmp = function(snmpData){
        for(var i = 0; i< snmpData.length;i++){
            if(snmpData[i].Type === 'master' || snmpData[i].Type === 'objectlist'){
                snmpData[i].closed = true;                   
            }
            else{
                snmpData[i].close = true;             
            }
        }
    };

    $scope.closeComputer = function(id,computerData){
        for(var i = 0; i< computerData.length;i++){
            if(computerData[i].ID == id){
                computerData[i].closed = true;                   
            }
            if(computerData[i].ParentId == id){
                computerData[i].close = true;
                $scope.closeComputer(computerData[i].ID,computerData);                    
            }
        }
    };

    $scope.expandSnmp = function(id,snmpData){
        for(var i = 0; i< snmpData.length;i++){
            if(snmpData[i].ID == id){
                snmpData[i].closed = false;                   
            }
            if(snmpData[i].ParentId == id){
                snmpData[i].close = false;                  
            }
        }
    };

    $scope.expandComputer = function(id,computerData){
        for(var i = 0; i< computerData.length;i++){
            if(computerData[i].ID == id){
                computerData[i].closed = false;                   
            }
            if(computerData[i].ParentId == id){
                computerData[i].close = false;                  
            }
        }
    };

    $scope.changeSnmp = function(active,parentId,snmpData){
        if(active==1){
            for(var i = 0; i< snmpData.length;i++){
                if(snmpData[i].ID == parentId){
                    snmpData[i].Active = 1;
                    if(snmpData[i].ParentId != null){
                        $scope.changeSnmp(1,snmpData[i].ParentId,snmpData)
                    }                    
                }
            }
        }
        else{
            var inactive = true;
            for(var i = 0; i< snmpData.length;i++){
                if(snmpData[i].ParentId == parentId){
                    if(snmpData[i].Active == 1){
                        inactive=false;
                        break;
                    }                
                }
            }
            if(inactive){
                for(var i = 0; i< snmpData.length;i++){
                    if(snmpData[i].ID == parentId){
                        snmpData[i].Active=0;
                        if(snmpData[i].ParentId != null){
                            $scope.changeSnmp(0,snmpData[i].ParentId,snmpData)
                        }              
                    }
                }
            }
        }
    }

    $scope.changeComputer = function(active,parentId,computerData){
        if(active==1){
            for(var i = 0; i< computerData.length;i++){
                if(computerData[i].ID == parentId){
                    computerData[i].Active = 1;
                    if(computerData[i].ParentId != null){
                        $scope.changeComputer(1,computerData[i].ParentId,computerData)
                    }                    
                }
            }
        }
        else{
            var inactive = true;
            for(var i = 0; i< computerData.length;i++){
                if(computerData[i].ParentId == parentId){
                    if(computerData[i].Active == 1){
                        inactive=false;
                        break;
                    }                
                }
            }
            if(inactive){
                for(var i = 0; i< computerData.length;i++){
                    if(computerData[i].ID == parentId){
                        computerData[i].Active=0;
                        if(computerData[i].ParentId != null){
                            $scope.changeComputer(0,computerData[i].ParentId,computerData)
                        }              
                    }
                }
            }
        }
    }

    $scope.removeSnmpItem = function(event){
        if(confirm("Deseja mesmo remover o item selecionado e todos os seus subitens?")){
            window.location = event;
        }
    }

    $scope.removeComputerItem = function(event){
        if(confirm("Deseja mesmo remover o item selecionado e todos os seus subitens?")){
            window.location = event;
        }
    }

    $scope.saveSnmpStructure = function(model){
        var parameter = JSON.stringify(model);
        $('#Structure').val(parameter);
        $('#formSnmpStructure').submit();
    }

    $scope.saveComputerStructure = function(model){
        var parameter = JSON.stringify(model);
        $('#Structure').val(parameter);
        $('#formComputerStructure').submit();
    }

    $scope.executeAction = function(event){
        window.location = event;
    }

    $scope.removeClass = function(event){
        if(confirm("Deseja mesmo remover esta classe e todos os seus subitens?")){
            window.location = event;
        }
    }
});
