<?php
/**
 * Created : 2 mai 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
if (isset($_REQUEST["label_id"])) {
    $vue->set($_REQUEST["label_id"], "label_id");
}
require_once 'modules/classes/label.class.php';
$label = new Label($bdd, $ObjetBDDParam);
$vue->set($label->getListe(2), "labels");

require_once 'modules/classes/printer.class.php';
$printer = new Printer($bdd, $ObjetBDDParam);
$vue->set($printer->getListe(2), "printers");
if (isset($_REQUEST["printer_id"])) {
    $vue->set($_REQUEST["printer_id"], "printer_id");
}
?>