{assign var="_PL_activeId" value=$PL->getActiveId()}
{assign var="SCRATCHPAD" value=$SCRATCHPAD->get()}

<!-- start scratch pad -->
<form name="SP">
    <div class="container_elements">
        <h1>##ScratchPad##</h1>
        <div class="head" style="width:255px; height: 21px;">&nbsp;</div>
        <div class="container_table" style="width:275px;">
            <table style="width:255px;">

            <!-- start table header -->
                <tr class="blue_head">
                    <td style="width: 1px"><input type="checkbox" name="all" onClick="collector_switchAll('SP')"></td>
                    <td style="width: *"><a href="#" onClick="hpopup('{$UI_HANDLER}?act=SP.reorder&by=title', 'order');" id="blue_head">##Title##</a></td>
                    <td style="width: 1px"><a href="#" onClick="hpopup('{$UI_HANDLER}?act=SP.reorder&by=title', 'order');" id="blue_head">##Duration##</td>
                    <td style="width: 1px; border: 0; text-align: center"><a href="#" onClick="hpopup('{$UI_HANDLER}?act=SP.reorder&by=title', 'order');" id="blue_head">##Type##</td>
                </tr>
            <!-- end table header -->

    {if count($SCRATCHPAD) >= 1}
        {foreach from=$SCRATCHPAD item=i}
                <!-- start item -->
                <tr class="{cycle values='blue1, blue2'}" id="scratchpad_item_{$i.id}">
                    <td><input type="checkbox" class="checkbox" name="{$i.id}"/></td>
                    <td {include file="scratchpad/actionhandler.tpl"} style="cursor: pointer">
                        {if $i.type|lower == "playlist"}

                            {if $_PL_activeId == $i.id}
                                <div style="font-weight: bold; cursor: pointer">
                            {else}
                                <div style="cursor: pointer">
                            {/if}
                                {$i.title|truncate:14:"...":true}
                                </div>
                        {else}
                            {$i.title|truncate:14:"...":true}
                        {/if}  {* for some reason object call doesn't like usage of array *}
                    </td>
                    {assign var="_duration" value=$i.duration}
                    <td {include file="scratchpad/actionhandler.tpl"} style="text-align: right; cursor: pointer">{niceTime in=$_duration}</td>
                    <td {include file="scratchpad/actionhandler.tpl"} style="border: 0; text-align: center; cursor: pointer">
                        {if $PL->isAvailable($i.id) == false}
                            <div align="left"><img src="img/ico_lock.png">
                            <img src="img/{$i.type}.png" border="0" alt="{$i.type|capitalize}" {* include file="sub/alttext.tpl"*} /></div>
                        {else}
                        <img src="img/{$i.type}.png" border="0" alt="{$i.type|capitalize}" {* include file="sub/alttext.tpl" *} /> {/if}
                    </td>
                </tr>
                <!-- end item -->
                
                
                
                <script type="text/javascript">
                var tool_tip = $("<div class='sp_tool_tip'/>"),
                	tool_tip_content = $("<table/>"),
                	playlist_content = $("<table/>"),
                    title = "{$i.title}",
                    id = "{$i.id}",
                    type = "{$i.type}",
                    creator = "{$i.creator}",
                    duration = "{$i.duration}",
    				source = "{$i.source}", 
    				bitRate = "{$i.bitRate}",
    				sampleRate = "{$i.sampleRate}",
    				content = "{$i.content}";

                {literal}
                
                tool_tip_content.append("<tr><td>Title: </td><td>"+title+"</td></tr>");

                if(type === "audioclip")
                	tool_tip_content.append("<tr><td>Artist: </td><td>"+creator+"</td></tr>");

            	if(type === "playlist")
                    tool_tip_content.append("<tr><td>Creator: </td><td>"+creator+"</td></tr>");
             
                if(type === "audioclip") {
					bitRate = bitRate.substr(0, 3);
                    
                	tool_tip_content.append("<tr><td>Album: </td><td>"+source+"</td></tr>");
                	tool_tip_content.append("<tr><td>Bit Rate: </td><td>"+bitRate+" kbps</td></tr>");
                	tool_tip_content.append("<tr><td>Sample Rate: </td><td>"+sampleRate+" Hz</td></tr>");
                }

				duration = duration.split(".");
				duration = duration[0].split(":");

				if(duration[0] == ''){
					duration = "00:00";
				}
				else if(parseInt(duration[0]) !== 0) {
					duration = duration[0] +":"+duration[1]+":"+duration[2];
				}
				else{
					duration = duration[1]+":"+duration[2];
				}
				
                tool_tip_content.append("<tr><td>Duration: </td><td>"+duration+"</td></tr>");

                if(type === "playlist") {
                	content = content.split("/");
                	for(var i=0; i< content.length; i++){
                		playlist_content.append("<tr><td>" +content[i]+ "</td></tr>");
                    }
                }

                tool_tip.append(tool_tip_content);
                tool_tip.append(playlist_content);

                $("#scratchpad_item_"+id).qtip({
            	   content: tool_tip,
            	   style: {name: 'cream'},
            	   position: {
                	   corner: {
                	   	target: "rightMiddle",
                	   	tooltip: "leftMiddle"
                	   }
                	},       	   
            	   show: 'mouseover',
            	   hide: 'mouseout'
                })
                </script>
                
                {/literal}
        {/foreach}
    {else}
        <tr class="blue1">
            <td style="border: 0" colspan="4" align="center">##empty##</td>
        </tr>
    {/if}
            </table>
        </div>

        <div class="footer" style="width:250px;">
            <select name="SP_multiaction" onChange="collector_submit('SP', this.value)">
                <option>##Multiple Action:##</option>
                <option value="SP.removeItem">##Remove files##</option>
                {if $_PL_activeId}
                    <option value="PL.addItem">##Add files to open Playlist##</option>
                {else}
                    <option value="PL.create">##New playlist using these files##</option>
                {/if}
            </select>
            <script type="text/javascript">
                // due to browser remembers filled form fields, here this is unwanted behavior
                document.forms['SP'].elements['SP_multiaction'].options[0].selected = true;
                document.forms['SP'].elements['all'].checked = false;
                collector_switchAll('SP');
            </script>
            <a href="#" onClick="collector_clearAll('SP', 'SP.removeItem')" id="blue_head">##Clear##</a>
        </div>

    </div>
</form>
<!-- end scratch pad -->

{assign var="_PL_activeId" value=null}
{assign var="_duration"    value=null}