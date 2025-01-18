#set text(font: "Helvetica", size: 12pt)
#set document(title: "Elaborato", author: "Nicolo' Luigi Allegris")

= Organizzazione
La prima cosa che ho fatto per organizzare il progetto è stata disegnare
l'automa che riconosce gli schemi default, questo mi ha permesso di avere
già dall'inizio un idea di come le funzioni si sarebbero dovute
chiamare tra di loro.
So che non è particolarmente gradibile all'occhio ma questo è l'automa dello
schema default.

#align(center, image("assets/automa1.png"))

Successivamente ho disegnato l'automa per l'authority.

#align(center, image("assets/automa2.png", width: 50%))

Ho saltato gli automi degli schemi speciali in quanto gli ho trovati abbastanza
"staightforward" e non ho avuto bisogno di disegnarli.

Per quanto riguarda l'automa che riconosce un indirizzo ip l'ho disegnato su
carta per ragioni organizzative e non l'ho digitalizzato.

Successivamente ho proceduto con la scrittura del codice, e infine ho scritto
dei test per verificarne la correttezza.

= Struttura del progetto
Il progetto come da suggerimento presente nella specifica è strutturato come
un insieme di funzioni mutualmente ricorsive, dove ogni funzione rappresenta
uno stato dell'automa.

Per Julia ho deciso di dividere il progetto su più file, infatti ho trovato
che dividere il progetto rispetto all'automa che implementa rende il progetto
molto meglio organizzato.
