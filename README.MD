<br><br><hr>
<h1>Dependencies</h1><br>
<h2><a href = "https://forum.cfx.re/t/release-pd-safe-standalone-lua-safecracking-minigame/1231799"><strong>safecraking-minigame</strong></a></h2><br>
<h2><a href = "https://github.com/HalCroves/mythic_progbar"><strong>mythic_progbar</strong></a></h2><br>
<h2><a href = "https://github.com/JayMontana36/mythic_notify"><strong>mythic_progbar</strong></a></h2><br>
<h2><a href = "https://github.com/esx-framework/es_extended"><strong>es_extended</strong></a></h2><br>

<br><br><hr>

<h1>!!! IMPORTANT !!!</h1>
<p>
1. Make sure you have the following tables inside your database owned_shops/owned_shops_storage/shops/items/fuel_stations/deliverymissionitems
   <ul>
      <li>shops</li>
      <li>items</li>
      <li>owned_shops</li>
      <li>fuel_stations</li>
      <li>owned_shops_storage</li>
      <li>deliverymissionitems</li>
   </ul>
<br><br>
2. Make sure the items in the shop also exist in your server else the script will give an error out when moving an invalid item from storage or when a player buys it.<br><br>
3. Make sure you have the items in Config.Items and also in Config.Images as well if the image of the item doesn't exist it is replaced by an image of a box.
<br><br>
4. No support is offered for this script anymore if you wish to use it you have to configure it yourself.
<br><br>
5. If you find any bugs please flag them in this repository and I might look at them but won't bother to if you don't provide a way to recreate the bug.
<br><br>
</p>

<br><br><hr>

<h1>Instructions</h1>
<ol>
   <li>The script is good to go as long as you have the dependencies installed and the database correctly configured.</li>
   <li>You can configure the script via the config.lua from inside PMShops and PMFuel one config.lua per file.</li>
 </ol>
