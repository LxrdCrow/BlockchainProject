// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

//Contratto per la raccolta dei fondi
contract RaccoltaFondi {
    uint public saldoTotale; 
    uint public obbiettivo;
    uint public numeroDonatori;
    address public manager;
    bool public raccoltaConclusa;

    event donazione(address donatore, uint importo); //evento donazione

    //Costruttore del contratto
    constructor (uint _obbiettivo) {
        manager = msg.sender;
        obbiettivo = _obbiettivo;
        raccoltaConclusa = false;

    }

    //Funzione per effettuare la donazione (payable)
    function donazioneFondo() public payable {
        require(!raccoltaConclusa, "Raccolta fondi conclusa");
        require(msg.value > 0, "La donazione deve essere maggiore di zero");
        emit donazione (msg.sender, msg.value);

        saldoTotale += msg.value;
        numeroDonatori++;

    }

    //Funzione per prelevare la donazione
    function prelievo() public {
        require(msg.sender == manager, "Il manager preleva la donazione");
        require (raccoltaConclusa, "Raccolta fondi ancora non conclusa");
        
        payable(manager).transfer(saldoTotale);
        saldoTotale = 0;
    }

    //Funzione per la chiusura della raccolta donazioni
    function chiusuraDonazioni() public {
        require(msg.sender == manager, "Solo il manager chiude la raccolta");
        require(!raccoltaConclusa, "Raccolta fondi terminata");

        raccoltaConclusa = true;
    }

    //Funzione di verifica dell'obbiettivo raggiunto
    function valutazioneDonazioni() public view returns (bool) {
        return (saldoTotale) >= obbiettivo;
    }
}