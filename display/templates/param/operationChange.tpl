<script type="text/javascript" src="display/javascript/alpaca/js/defineForm.js"></script>

<script type="text/javascript">
function loadSchema(){

}

$(document).ready(function() {

        var metadataParse= $("#metadataField").val();
        if (metadataParse.length > 0) {
            metadataParse = metadataParse.replace(/&quot;/g,'"');
            metadataParse = JSON.parse(metadataParse);
        }
        renderForm(metadataParse);

        $('#operationForm').submit(function(event) {
        	console.log("write");
        	if ($("#action").val() == "Write") {
        		$('#metadata').alpaca().refreshValidationState(true);
                if(!$('#metadata').alpaca().isValid(true)){
                	alert("La définition des métadonnées n'est pas valide.");
                	event.preventDefault();
                }
        	}
        });        
    });
</script>

{if $nbSample>0}
<div class="col-md-12 message">
<span class="red"> Cette opération n'est pas modifiable, car il existe des échantillons qui lui sont associés.</span>
</div>
<br/>
<input type="button" class="btn btn-primary button-valid" value="En créer une nouvelle version" onclick="location.href='index.php?module=operationChange&operation_id=0&operation_pere_id={$data.operation_id}'">

{/if}

<h2>Modification d'une operation</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=operationList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="operationForm" method="post" action="index.php" enctype="multipart/form-data">
{if $nbSample > 0}<fieldset disabled>{/if}
<input type="hidden" name="moduleBase" value="operation">
<input type="hidden" id="action" name="action" value="Write">
<input type="hidden" name="operation_id" value="{$data.operation_id}">
<input type="hidden" name="metadata_schema" id="metadataField" value="{$data.metadata_schema}">
<div class="form-group">
<label for="protocolId"  class="control-label col-md-4">Protocole<span class="red">*</span> :</label>
<div class="col-md-8">
<select id="protocolId" name="protocol_id" class="form-control" autofocus>
{section name=lst loop=$protocol}
<option value="{$protocol[lst].protocol_id}" {if $data.protocol_id == $protocol[lst].protocol_id}selected{/if}>
{$protocol[lst].protocol_year} {$protocol[lst].protocol_name} {$protocol[lst].protocol_version}
</option>
{/section}
</select>
</div>
</div>

<div class="form-group">
<label for="operationName"  class="control-label col-md-4">Nom de l'opération<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="operationName" type="text" class="form-control" name="operation_name" value="{if $operation_pere_id>0}{section name=lst loop=$operations}{if $operations[lst].operation_id == $operation_pere_id}{$operations[lst].operation_name}{/if}{/section}{else}{$data.operation_name}{/if}" required autofocus>
</div>
</div>

<div class="form-group">
<label for="operationVersion"  class="control-label col-md-4">Version de l'opération<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="operationVersion" type="text" class="form-control" name="operation_version" value="{$data.operation_version}" required>
</div>
</div>

<div class="form-group">
<label for="operationOrder"  class="control-label col-md-4">N° d'ordre :</label>
<div class="col-md-8">
<input id="operationOrder" type="number" class="form-control" name="operation_order" value="{$data.operation_order}">
</div>
</div>


<fieldset>
<legend>Jeu de métadonnées</legend>


<div id="metadata"></div>

</fieldset>

{if $nbSample < 1}
<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.operation_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
 {/if}
 {if $nbSample > 0}</fieldset>{/if}
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>