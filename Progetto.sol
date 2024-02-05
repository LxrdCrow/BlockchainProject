// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

// Contratto di raccolta fondi
contract RaccoltaFondi {
    // Variabili di stato
    address public manager;           // Indirizzo del manager della raccolta fondi
    uint public saldoTotale;          // Saldo totale raccolto
    uint public obiettivo;            // Obiettivo impostato dal creatore della raccolta
    mapping(address => uint256) public importoDonatoPerDonatore; // Mapping da indirizzo a importo donato
    bool public raccoltaConclusa;     // Flag per indicare se la raccolta fondi è conclusa

    // Evento emesso al momento di una donazione
    event Donazione(address donatore, uint importo);

    // Costruttore del contratto
    constructor(uint _obiettivo) {
        manager = msg.sender;           // Imposta il creatore come manager iniziale
        obiettivo = _obiettivo;         // Imposta l'obiettivo iniziale
        raccoltaConclusa = false;       // La raccolta parte aperta
    }

    // Funzione per effettuare una donazione (payable)
    function dona() public payable {
        require(!raccoltaConclusa, "Raccolta fondi conclusa");
        require(msg.value > 0, "L'importo della donazione deve essere maggiore di zero");

        // Aggiorna le variabili di stato
        saldoTotale += msg.value;
        importoDonatoPerDonatore[msg.sender] += msg.value;

        // Emette l'evento di donazione
        emit Donazione(msg.sender, msg.value);
    }

    // Funzione per prelevare gli Ether raccolti (riservata al manager)
    function preleva() public {
        require(msg.sender == manager, "Solo il manager preleva gli Ether");
        require(raccoltaConclusa, "Raccolta fondi non ancora conclusa");

        // Trasferisce gli Ether al manager
        payable(manager).transfer(saldoTotale);

        // Resetta il saldo
        saldoTotale = 0;
    }

    // Funzione per chiudere la raccolta fondi (riservata al manager)
    function chiudiRaccolta() public {
        require(msg.sender == manager, "Solo il manager chiude la raccolta fondi");
        require(!raccoltaConclusa, "Raccolta fondi conclusa");

        // Imposta il flag di chiusura
        raccoltaConclusa = true;
    }

    // Funzione per controllare se l'obiettivo è stato raggiunto
    function obiettivoRaggiunto() public view returns (bool) {
        return saldoTotale >= obiettivo;
    }
}
