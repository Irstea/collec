<h2>Import d'échantillons ou de containers à partir d'un fichier CSV</h2>
<div class="row">
<div class="col-md-6">
<div class="bg-info">
Ce module permet d'importer des échantillons ou des containers, et de créer le cas échéant les mouvements d'entrée.
<br>
Il n'accepte que des fichiers au format CSV. La ligne d'entête doit comprendre exclusivement les colonnes suivantes :
<br>
<ul>
<li><b>sample_identifier</b> : l'identifiant de l'échantillon (obligatoire)</li>
<li><b>project_id</b> : le numéro informatique du projet (obligatoire)</li>
<li><b>sample_type_id</b> : le numéro informatique du type d'échantillon (obligatoire)</li>
<li><b>sample_date</b> : la date de création de l'échantillon, au format dd/mm/yyyy</li>
<li><b>sample_range</b> : l'emplacement de rangement de l'échantillon dans le container</li>
<li><b>container_identifier</b> : l'identifiant du container (obligatoire)</li>
<li><b>container_type_id</b> : le numéro informatique du type de container (obligatoire)</li>
<li><b>container_status_id</b> : le numéro informatique du statut que prendra le container</li>
<li><b>container_range</b> : l'emplacement de rangement du container dans son parent</li>
<li><b>container_parent_uid</b> : l'UID du container parent</li>
</ul>
Les codes informatiques peuvent être consultés à partir du menu <i>Paramètres</i>.
<br>
L'import sera réalisé ainsi :
<ol>
<li>si sample_identifier est renseigné : création de l'échantillon</li>
<li>si container_identifier est renseigné : création du container</li>
<li>si container_parent_uid est renseigné : création du mouvement d'entrée du container</li>
<li>si l'échantillon et le container ont été créés, création du mouvement d'entrée de l'échantillon dans le container</li>
</ol>
</div>
</div>
</div>
<div class="row col-md-6">
<form class="form-horizontal protoform" id="controlForm" method="post" action="index.php" enctype="multipart/form-data">
<input type="hidden" name="module" value="importControl">
<div class="form-group">
<label for="upfile" class="control-label col-md-4">Nom du fichier à importer (CSV)<span class="red">*</span> :</label>
<div class="col-md-8">
<input type="file" name="upfile" required>
</div>
</div>
<div class="form-group">
<label for="separator" class="control-label col-md-4">Séparateur utilisé :</label>
<div class="col-md-8">
<select id="separator" name="separator">
<option value="," {if $separator == ","}selected{/if}>Virgule</option>
<option value=";" {if $separator == ";"}selected{/if}>Point-virgule</option>
<option value="tab" {if $separator == "tab"}selected{/if}>Tabulation</option>
</select>
</div>
</div>
<div class="form-group">
<label for="utf8_encode" class="control-label col-md-4">Encodage du fichier :</label>
<div class="col-md-8">
<select id="utf8_encode" name="utf8_encode">
<option value="0" {if $utf8_encode == 0}selected{/if}>UTF-8</option>
<option value="1" {if $utf8_encode == 1}selected{/if}>ISO-8859-x</option>
</select>
</div>
</div>
<div class="form-group center">
      <button type="submit" class="btn btn-primary">Lancer les contrôles</button>
</div>
</form>


<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>
</div>


<!-- Affichage des erreurs decouvertes -->
{if $erreur == 1}
<div class="row col-md-12">
<table id="containerList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>N° de ligne</th>
<th>Anomalie(s) détectée(s)</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$erreurs}
<tr>
<td class="center">{$erreurs[lst].line}</td>
<td>{$erreurs[lst].message}</td>
</tr>
{/section}
</tbody>
</table>
</div>
{/if}

<!-- Lancement de l'import -->
{if $controleOk == 1}
<div class="row col-md-8">
<form id="importForm" method="post" action="index.php">
<input type="hidden" name="module" value="importImport">
Contrôles OK. Vous pouvez réaliser l'import du fichier {$filename} : 
<button type="submit" class="btn btn-danger">Déclencher l'import</button>
</form>
</div>
{/if}