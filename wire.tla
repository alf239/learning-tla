-------------------------------- MODULE wire --------------------------------

EXTENDS Integers

(*--algorithm wire
variables
    people = { "alice", "bob" },
    acc = [p \in people |-> 5],
    sender = "alice",
    receiver = "bob",
    amount \in 1..5;

define
    NoOverdrafts == \A p \in people: acc[p] >= 0
end define;

begin 
    Withdraw:
        acc[sender] := acc[sender] - amount;
    Deposit:
        acc[receiver] := acc[receiver] + amount;
end algorithm;

*)
\* BEGIN TRANSLATION (chksum(pcal) = "6a185f37" /\ chksum(tla) = "7df88afe")
VARIABLES people, acc, sender, receiver, amount, pc

(* define statement *)
NoOverdrafts == \A p \in people: acc[p] >= 0


vars == << people, acc, sender, receiver, amount, pc >>

Init == (* Global variables *)
        /\ people = { "alice", "bob" }
        /\ acc = [p \in people |-> 5]
        /\ sender = "alice"
        /\ receiver = "bob"
        /\ amount \in 1..5
        /\ pc = "Withdraw"

Withdraw == /\ pc = "Withdraw"
            /\ acc' = [acc EXCEPT ![sender] = acc[sender] - amount]
            /\ pc' = "Deposit"
            /\ UNCHANGED << people, sender, receiver, amount >>

Deposit == /\ pc = "Deposit"
           /\ acc' = [acc EXCEPT ![receiver] = acc[receiver] + amount]
           /\ pc' = "Done"
           /\ UNCHANGED << people, sender, receiver, amount >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Withdraw \/ Deposit
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sat Jun 12 14:29:15 BST 2021 by alf
\* Created Sat Jun 12 13:43:37 BST 2021 by alf
