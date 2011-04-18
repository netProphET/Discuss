[[+trail]]

[[!FormIt?
  &submitVar=`dis-post-modify`
  &hooks=`postHook.DiscussModifyPost`
  &validate=`title:required,message:required:allowTags`
]]

<div id="dis-modify-post-preview">[[+preview]]</div>
<br />
<form action="[[~[[*id]]]]thread/modify?post=[[+id]]" method="post" class="dis-form" id="dis-modify-post-form" enctype="multipart/form-data">

    <h2>[[%discuss.post_modify? &namespace=`discuss` &topic=`post`]]</h2>
    
    <input type="hidden" name="board" value="[[!+fi.board]]" />
    <input type="hidden" name="post" value="[[!+fi.post]]" />
    <input type="hidden" name="thread" value="[[!+fi.thread]]" />
    
    <label for="dis-new-thread-title">[[%discuss.title]]:
        <span class="error">[[!+fi.error.title]]</span>
    </label>
    <input type="text" name="title" id="dis-new-thread-title" value="[[!+fi.title]]" />

    <div style="margin-left: 150px;">
        <br class="clear" />
        [[+buttons]]
        <br class="clear" />
    </div>
    
    <label for="dis-thread-message">[[%discuss.message]]:
        <span class="error">[[!+fi.error.message]]</span>
    </label>
    <textarea name="message" id="dis-thread-message" cols="80" rows="7">[[!+fi.message]]</textarea>
    <br class="clear" />

    <label for="dis-attachment">[[%discuss.attachments]]:
        <span class="small dis-add-attachment"><a href="javascript:void(0);">[[%discuss.attachment_add]]</a>
        <br />([[%discuss.attachments_max? &max=`[[+max_attachments]]`]])</span>
        <span class="error">[[+error.attachments]]</span>
    </label>
    <input type="file" name="attachment[[+attachmentCurIdx]]" id="dis-attachment" />

    <div id="dis-attachments"></div>
    [[+attachments:notempty=`<div class="dis-existing-attachments">
        <ul>[[+attachments]]</ul>
    </div>`]]
    <br class="clear" />
   
    <label class="dis-cb"><input type="checkbox" name="locked" value="1" [[!+fi.locked:FormItIsChecked=`1`]] />[[%discuss.thread_lock? &namespace=`discuss` &topic=`web`]]</label>
    <label class="dis-cb"><input type="checkbox" name="sticky" value="1" [[!+fi.sticky:FormItIsChecked=`1`]] />[[%discuss.thread_stick]]</label>

    <br class="clear" />
    <div class="dis-form-buttons">
        <input type="submit" class="dis-action-btn" name="dis-post-modify" value="[[%discuss.save_changes]]" />
        <input type="button" class="dis-action-btn dis-modify-post-preview-btn" id="dis-modify-post-preview-btn" value="[[%discuss.preview]]" />
        <input type="button" class="dis-action-btn" value="[[%discuss.cancel]]" onclick="location.href='[[~[[*id]]]]thread/?thread=[[+thread]]#dis-post-[[+id]]';" />
    </div>
</form>

<br />
<hr />
<div class="dis-thread-posts">
    <h2>[[%discuss.thread_summary]]</h2>
[[+thread_posts:default=`<p>[[%discuss.thread_no_posts]]</p>`]]
</div>
[[+discuss.error_panel]]