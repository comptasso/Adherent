// fonction pour transformer une chaine avec virgule en float
// la fonction retire les espaces et remplace la virgule par le point décimal
// avant d'appeler Number, la fonction native de js.
function stringToFloat(jcdata) {

    if (jcdata === undefined) {
        return 0.0;
    }
    var d = String(jcdata).replace(/,/, '.');
    d = d.replace(/\s/g, '');
    if (isNaN(d)) {
        return 0.0;
    } else {
        return Number(d);
    }
}

// fonction permettant de mettre deux décimales à un nombre
// appelé lorsque l'utilisateur sort d'un champ pour remettre en forme sa saisir
// Par exemple 32 devient 32.00 ou 32.5 devient 32.50
function $f_two_decimals() {
    var number = stringToFloat(this.value);
    if (isNaN(number)) {
        this.value = '0.00';
    } else {
        this.value = number.toFixed(2);
    }
}

// série de fonction qui prépare les champs débit et crédit pour la saisie
// quand on entre dans un champ qui est à 0, on le vide
function $f_empty() {
    if (this.value === '0.00') {
        this.value = '';
    }
}

jQuery(function () {
    $('#main-zone').on('focus', '.decimal', $f_empty); //vide le champ s'il est à zero (pour faciliter la saisie)
    $('#main-zone').on('blur', '.decimal', $f_two_decimals);
});
