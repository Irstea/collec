<?php
require_once 'modules/classes/campaign.class.php';
$dataClass = new Campaign($bdd, $ObjetBDDParam);
$keyName = "campaign_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        /*
         * Display the list of all records of the table
         */
        $vue->set($dataClass->getListe(2), "data");
        $vue->set("param/campaignList.tpl", "corps");
        break;
    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        dataRead($dataClass, $id, "param/campaignChange.tpl");
        require_once "modules/classes/regulation.class.php";
        $regulation = new Regulation($bdd, $ObjetBDDParam);
        $vue->set($regulation->getListe(2), "regulations");
        break;
    case "write":
        /*
         * write record in database
         */
        $id = dataWrite($dataClass, $_REQUEST);
        if ($id > 0) {
            $_REQUEST[$keyName] = $id;
        }
        break;
    case "delete":
        /*
         * delete record
         */
        dataDelete($dataClass, $id);
        break;
}