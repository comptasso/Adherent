

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







