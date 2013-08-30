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
}

$(document).ready( function () {
    $('#members_id').dataTable({
      "oLanguage": frenchdatatable
    });
} );