<?php
include_once 'modules/classes/export/exportTemplate.class.php';
$dataClass = new ExportTemplate($bdd, $ObjetBDDParam);
$keyName = "export_template_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
  case "list":
    /*
		 * Display the list of all records of the table
		 */
    $vue->set($dataClass->getListe(2), "data");
    $vue->set("export/exportTemplateList.tpl", "corps");
    break;
  case "display":
    /*
		 * Display the detail of the record
		 */
    $vue->set($dataClass->lire($id), "data");
    $vue->set("export/exportTemplateDisplay.tpl", "corps");
    break;
  case "change":
    /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record 
		 */
    dataRead($dataClass, $id, "export/exportTemplateChange.tpl");
    include_once "modules/classes/export/datasetTemplate.class.php";
    $dt = new DatasetTemplate($bdd, $ObjetBDDParam);
    $vue->set($dt->getListFromExportTemplate($id), "datasets");
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
