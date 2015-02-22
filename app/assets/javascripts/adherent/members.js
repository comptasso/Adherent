// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var frenchdatatable = {
    "sProcessing":   "Traitement en cours...",
    "sLengthMenu":   "Afficher _MENU_ éléments",
    "sZeroRecords":  "Aucun élément à afficher",
    "sInfo":         "Affichage de l'élement _START_ à _END_ sur _TOTAL_ éléments",
    "sInfoEmpty":    "Affichage de l'élement 0 à 0 sur 0 éléments",
    "sInfoFiltered": "(filtré de _MAX_ éléments au total)",
    "sInfoPostFix":  "",
    "sSearch":       "Rechercher :",
    "sUrl":          "",
    "oPaginate": {
        "sFirst":    "Premier",
        "sPrevious": "Précédent",
        "sNext":     "Suivant",
        "sLast":     "Dernier"
    }
};


// dateHeight transforme une date au format français en un chiffre
// ce qui permet les comparaisons pour le tri des tables
// dateStr est au format jj/mm/aaaa
function dateHeight(dateStr) {
  // on cherche les 4 derniers chiffres
  var arr = dateStr.split('/');
  var val = arr[2] + arr[1] + arr[0];
  return parseInt(val);
}


$(document).ready( function () {
    $('#members').dataTable({
      
      "aoColumnDefs": [
            {
                "sType": "date-euro",
                "asSortable": ['asc', 'desc'],
                "aTargets": ['date-euro'] // les colonnes date au format français ont la classe date-euro
            },
            {
                "bSortable": false,
                "aTargets": ['actions' ]
            }]          
    });
} );

 // Valeurs par défaut pour les dataTables pour avoir la mise en page 
// voulue pour les 4 accessoires (search, pagination,...)
$.extend($.fn.dataTable.defaults, {
    "sDom": "<'col-lg-6'l>frt<'col-lg-6'i><'col-lg-6'p>",
    "oLanguage": frenchdatatable,
    "iDisplayLength": 10,
    "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "Tous"]],
    "bStateSave": true, // pour pouvoir sauvegarder l'état de la table
    "fnStateSave": function (oSettings, oData) { //localStorage avec un chemin pour que les
      // paramètres spécifiques  aux cash_lines soient mémorisés.
        localStorage.setItem('DataTables_' + window.location.pathname, JSON.stringify(oData));
    },
    "fnStateLoad": function (oSettings) {
        return JSON.parse(localStorage.getItem('DataTables_' + window.location.pathname));
    }
});


// Les colonnes qui doivent être triées selon les dates au format français 
// doivent avoir comme classe date-euro (%th.date-euro).
// Dans la fonction datatable il suffit alors d'indiquer que les colonne 
// sont de type date-euro (sType: date-euro, aTargets: [date-euro]
jQuery.fn.dataTableExt.oSort['date-euro-asc'] = function(a, b) {
                        var x = dateHeight(a);
                        var y = dateHeight(b);
                        var z = ((x < y) ? -1 : ((x > y) ? 1 : 0));
                        return z;
                };

jQuery.fn.dataTableExt.oSort['date-euro-desc'] = function(a, b) {
                        var x = dateHeight(a);
                        var y = dateHeight(b);
                        var z = ((x < y) ? 1 : ((x > y) ? -1 : 0));
                        return z;
                };

// Gestion du tri des colonnes de montant
// fonctions de tri pour des nombres avec une virgule comme séparateur décimal
    jQuery.fn.dataTableExt.oSort['numeric-comma-asc']  = function(a,b) {
    var x = (a == "-") ? 0 : a.replace( /,/, "." );
    var y = (b == "-") ? 0 : b.replace( /,/, "." );
    x = parseFloat( x );
    y = parseFloat( y );
    return ((x < y) ? -1 : ((x > y) ?  1 : 0));
};

jQuery.fn.dataTableExt.oSort['numeric-comma-desc'] = function(a,b) {
    var x = (a == "-") ? 0 : a.replace( /,/, "." );
    var y = (b == "-") ? 0 : b.replace( /,/, "." );
    x = parseFloat( x );
    y = parseFloat( y );
    return ((x < y) ?  1 : ((x > y) ? -1 : 0));
};



//plug in permettant d'ajouter le type comma-decimals aux colonnes'
// cette méthode qui pourrait être utilisée pour les dates 
// permet à datatable d'identifier de lui même le type de la colonne
jQuery.fn.dataTableExt.aTypes.unshift(
    function ( sData )
    {
        var sValidChars = "0123456789-,";
        var Char;
        var bDecimal = false;

        /* Check the numeric part */
        for ( i=0 ; i<sData.length ; i++ )
        {
            Char = sData.charAt(i);
            if (sValidChars.indexOf(Char) == -1)
            {
                return null;
            }

            /* Only allowed one decimal place... */
            if ( Char == "," )
            {
                if ( bDecimal )
                {
                    return null;
                }
                bDecimal = true;
            }
        }

        return 'numeric-comma';
    }
);
  
