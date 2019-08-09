<?php

/**
 * Created : 8 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */

require_once 'modules/classes/container.class.php';
require_once 'modules/classes/object.class.php';

$dataClass = new Container($bdd, $ObjetBDDParam);
$keyName = "uid";
if (isset($_SESSION["uid"])) {
    $id = $_SESSION["uid"];
    unset($_SESSION["uid"]);
} else {
    $id = $_REQUEST[$keyName];
}
$_SESSION["moduleParent"] = "container";
switch ($t_module["param"]) {
    case "list":
        $_SESSION["moduleListe"] = "containerList";
        /*
         * Display the list of all records of the table
         */
        if (!isset($isDelete)) {
            $_SESSION["searchContainer"]->setParam($_REQUEST);
        }

        $dataSearch = $_SESSION["searchContainer"]->getParam();
        if ($_SESSION["searchContainer"]->isSearch() == 1) {
            $data = $dataClass->containerSearch($dataSearch);
            $vue->set($data, "containers");
            $vue->set(1, "isSearch");
        }
        $vue->set($dataSearch, "containerSearch");
        $vue->set("gestion/containerList.tpl", "corps");
        /*
         * Ajout des listes deroulantes
         */
        include 'modules/gestion/container.functions.php';
        /*
         * Ajout de la selection des modeles d'etiquettes
         */
        include 'modules/gestion/label.functions.php';
        break;
    case "display":
        /*
         * Display the detail of the record
         */
        $data = $dataClass->lire($id);
        $vue->set($data, "data");
        /*
         * Recuperation des identifiants associes
         */
        include_once 'modules/classes/objectIdentifier.class.php';
        $oi = new ObjectIdentifier($bdd, $ObjetBDDParam);
        $vue->set($oi->getListFromUid($data["uid"]), "objectIdentifiers");
        /*
         * Recuperation des contenants parents
         */
        $vue->set($dataClass->getAllParents($data["uid"]), "parents");
        /*
         * Recuperation des contenants et des échantillons contenus
         */
        $dcontainer = $dataClass->getContentContainer($data["uid"]);
        $dsample = $dataClass->getContentSample($data["uid"]);
        $vue->set($dcontainer, "containers");
        $vue->set($dsample, "samples");
        /*
         * Preparation du tableau d'occupation du container
         */
        $vue->set($dataClass->generateOccupationArray($dcontainer, $dsample, $data["columns"], $data["lines"], $data["first_line"]), "containerOccupation");
        $vue->set($data["lines"], "nblignes");
        $vue->set($data["columns"], "nbcolonnes");
        $vue->set($data["first_line"], "first_line");
        /*
         * Recuperation des evenements
         */
        include_once 'modules/classes/event.class.php';
        $event = new Event($bdd, $ObjetBDDParam);
        $vue->set($event->getListeFromUid($data["uid"]), "events");
        /*
         * Recuperation des mouvements
         */
        include_once 'modules/classes/movement.class.php';
        $movement = new Movement($bdd, $ObjetBDDParam);
        $vue->set($movement->getAllMovements($id), "movements");
        /*
         * Recuperation des reservations
         */
        include_once 'modules/classes/booking.class.php';
        $booking = new Booking($bdd, $ObjetBDDParam);
        $vue->set($booking->getListFromParent($data["uid"], 'date_from desc'), "bookings");
        /*
         * Recuperation des documents
         */
        include_once 'modules/classes/document.class.php';
        $document = new Document($bdd, $ObjetBDDParam);
        $vue->set($document->getListFromParent($data["uid"]), "dataDoc");
        $vue->set(1, "modifiable");
        /*
         * Ajout de la selection des modeles d'etiquettes
         */
        include 'modules/gestion/label.functions.php';
        /*
         * Ajout de la liste des referents, pour operations de masse sur les echantillons
         */
        include_once 'modules/classes/referent.class.php';
        $referent = new Referent($bdd, $ObjetBDDParam);
        $vue->set($referent->getListe(2), "referents");
        /**
         * Recuperation des types d'evenements
         */
        include_once 'modules/classes/eventType.class.php';
        $eventType = new EventType($bdd, $ObjetBDDParam);
        $vue->set($eventType->getListe(1), "eventType");
        /*
         * Affichage
         */
        $vue->set($_SESSION["APPLI_code"], "APPLI_code");
        $vue->set("container", "moduleParent");
        $vue->set("gestion/containerDisplay.tpl", "corps");
        include 'modules/gestion/mapInit.php';

        break;
    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        dataRead($dataClass, $id, "gestion/containerChange.tpl");
        if ($_REQUEST["container_parent_uid"] > 0 && is_numeric($_REQUEST["container_parent_uid"])) {
            $container_parent = $dataClass->lire($_REQUEST["container_parent_uid"]);
            $vue->set($container_parent["uid"], "container_parent_uid");
            $vue->set($container_parent["identifier"], "container_parent_identifier");
        }
        include 'modules/gestion/container.functions.php';
        include 'modules/gestion/mapInit.php';
        $vue->set(1, "mapIsChange");
        /*
         * Recuperation des referents
         */
        include_once 'modules/classes/referent.class.php';
        $referent = new Referent($bdd, $ObjetBDDParam);
        $vue->set($referent->getListe(2), "referents");

        break;
    case "write":
        /*
         * write record in database
         */
        $id = dataWrite($dataClass, $_REQUEST);
        if ($id > 0) {
            $_REQUEST[$keyName] = $id;
            /*
             * Recherche s'il s'agit d'un contenant a associer dans un autre contenant
             */
            if ($_REQUEST["container_parent_uid"] > 0 && is_numeric($_REQUEST["container_parent_uid"])) {
                include_once 'modules/classes/movement.class.php';
                $movement = new Movement($bdd, $ObjetBDDParam);
                $data = array(
                    "uid" => $id,
                    "movement_date" => date($_SESSION["MASKDATELONG"]),
                    "movement_type_id" => 1,
                    "login" => $_SESSION["login"],
                    "container_id" => $dataClass->getIdFromUid($_REQUEST["container_parent_uid"]),
                    "movement_id" => 0,
                    "line_number" => 1,
                    "column_number" => 1,

                );
                $movement->ecrire($data);
            }
        }
        break;
    case "delete":
        /*
         * delete record
         */
        /*
         * Recherche si le contenant est reference
         */
        include_once 'modules/classes/movement.class.php';
        $movement = new Movement($bdd, $ObjetBDDParam);
        try {
            $nb = $movement->getNbFromContainer($id);
        } catch (Exception $e) {
            $nb = 0;
        }
        if ($nb > 0) {
            $message->set(_("Le contenant est référencé dans les mouvements et ne peut être supprimé"), true);
            $module_coderetour = -1;
        } else {
            dataDelete($dataClass, $id);
        }

        $isDelete = true;
        break;

    case "getFromType":
        /*
         * Recherche la liste a partir du type
         */
        $vue->set($dataClass->getFromType($_REQUEST["container_type_id"]));
        break;
    case "getFromUid":
        /*
         * Lecture d'un container a partir de son uid
         */
        $vue->set($dataClass->lire($_REQUEST["uid"]));
        break;
    case "exportGlobal":
        $data = $dataClass->generateExportGlobal($_REQUEST["uids"]);
        $vue->setParam(
            array(
                "content_type" => "application/json",
                "filename" => "export-" . date('Y-m-d-His') . ".json"
            )
        );
        $vue->set(json_encode($data));
        break;
    case "importStage1":
        $vue->set("gestion/containerImport.tpl", "corps");
        $vue->set(0, "utf8_encode");
        break;
    case "importStage2":
        unset($_SESSION["filename"]);
        if (file_exists($_FILES['upfile']['tmp_name'])) {
            /*
         * Deplacement du fichier dans le dossier temporaire
         */
            $filename = $APPLI_temp . '/' . bin2hex(openssl_random_pseudo_bytes(4));
            if (copy($_FILES['upfile']['tmp_name'], $filename)) {
                try {
                    /**
                     * Get the content of the file
                     */
                    $handle = fopen($filename, "r");
                    $jdata = fread($handle, filesize($filename));
                    fclose($handle);

                    $data = json_decode($jdata, true);
                    if ($data["export_version"] != 1) {
                        throw new ImportException(
                            _("La version du fichier importé ne correspond pas à la version attendue")
                        );
                        $module_coderetour = -1;
                    }
                } catch (Exception $e) {
                    $module_coderetour = -1;
                    $message->set($e->getMessage(), true);
                }
                if ($module_coderetour == -1) {
                    /**
                     * delete of temporary file
                     */
                    unset($filename);
                } else {
                    $vue->set($dataClass->getAllNamesFromReference($data), "names");
                    require_once "modules/gestion/sample.functions.php";
                    $sic = new SampleInitClass();
                    $vue->set($sic->init(), "dataClass");
                    $vue->set($filename, "realfilename");

                    $vue->set($_REQUEST["utf8_encode"], "utf8_encode");
                    $vue->set(2, "stage");
                    $vue->set($_FILES['upfile']['name'], "filename");
                }
            } else {
                $message->set(_("Impossible de recopier le fichier importé dans le dossier temporaire"), true);
                $module_coderetour = -1;
            }
        } else {
            $message->set(_("Pas de fichier téléchargé"), true);
            $module_coderetour = -1;
        }
        $vue->set("gestion/containerImport.tpl", "corps");
        break;
    case "importStage3":
        if (isset($_REQUEST["realfilename"])) {
            if (file_exists($_REQUEST["realfilename"])) {
                try {
                    /**
                     * Open the file
                     */
                    $handle = fopen($_REQUEST["realfilename"], "r");
                    $jdata = fread($handle, filesize($filename));
                    fclose($handle);

                    $data = json_decode($jdata, true);
                    require_once 'modules/gestion/sample.functions.php';
                    $sic = new SampleInitClass();
                    try {
                        $bdd->beginTransaction();
                        $dataClass->importExternal($data, $sic, $_POST);
                        $result = $dataClass->getUidMinMax();
                        $message->set(sprintf(_("Import effectué. %s objets traités"), $result["number"]));
                        $message->set(sprintf(_("Premier UID généré : %s"), $result["min"]));
                        $message->set(sprintf(_("Dernier UID généré : %s"), $result["max"]));
                        $module_coderetour = 1;
                        $bdd->commit();
                    } catch (ImportObjectException $ie) {
                        $bdd->rollBack();
                        $message->set($ie->getMessage(), true);
                        $module_coderetour = -1;
                    } catch (Exception $e) {
                        $bdd->rollBack();
                        $message->set($e->getMessage(), true);
                        $module_coderetour = -1;
                    }
                } catch (Exception $e1) {
                    $message->set($e1->getMessage(), true);
                    $module_coderetour = -1;
                }
            }
        }
        break;
}
