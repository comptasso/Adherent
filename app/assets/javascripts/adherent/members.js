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

$(document).ready( function () {
    $('#members').dataTable({
      "oLanguage": frenchdatatable,
      "aoColumnDefs": [
            {
                "sType": "date-euro",
                "asSortable": ['asc', 'desc'],
                "aTargets": ['date-euro'] // les colonnes date au format français ont la classe date-euro
            }],
    });
} );

// dateHeight transforme une date au format français en un chiffre
// ce qui permet les comparaisons pour le tri des tables
// dateStr est au format jj/mm/aaaa
function dateHeight(dateStr) {
  // on cherche les 4 derniers chiffres
  var arr = dateStr.split('/');
  var val = arr[2] + arr[1] + arr[0];
  return parseInt(val)
}


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
