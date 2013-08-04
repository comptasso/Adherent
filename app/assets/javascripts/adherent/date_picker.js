/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


// fonction utilisée pour afficher un date picker pour chaque champ de class
// .input_date. Ces champs imput_date sont créés facilement par une extension de simple_form_form
//
// Date min et
// date max sont transmis par cette fonction sous forme d'attributs  data-jcmin et data-jcmax
jQuery(function () {
   jQuery.each($('.input_date_picker'), function (index, val) {
        
        $(val).datepicker(
            {
                dateFormat: 'dd/mm/yy',
                minDate: $(val).attr('data-jcmin'),
                maxDate: $(val).attr('data-jcmax')
            }
        );
    });
});

/* French initialisation for the jQuery UI date picker plugin. */
/* Written by Keith Wood (kbwood{at}iinet.com.au) and Stéphane Nahmani (sholby@sholby.net). */
jQuery(function ($) {
    $.datepicker.regional.fr = {
        closeText: 'Fermer',
        prevText: '&#x3c;Préc',
        nextText: 'Suiv&#x3e;',
        currentText: 'Courant',
        monthNames: ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'],
        monthNamesShort: ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'],
        dayNames: ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'],
        dayNamesShort: ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'],
        dayNamesMin: ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa'],
        weekHeader: 'Sm',
        dateFormat: 'dd/mm/yy',
        firstDay: 1,
        isRTL: false,
        showMonthAfterYear: false,
        yearSuffix: ''
    };
    $.datepicker.setDefaults($.datepicker.regional.fr);
});

