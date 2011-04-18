<?php
/**
 * Post a reply to a post
 *
 * @package discuss
 */
$discuss =& $modx->discuss;
$modx->lexicon->load('discuss:post');
$fields = $hook->getValues();
unset($fields[$submitVar]);

if (empty($fields['post'])) return $modx->error->failure($modx->lexicon('discuss.post_err_ns'));
$post = $modx->getObject('disPost',$fields['post']);
if ($post == null) return false;

$thread = $post->getOne('Thread');
if ($thread == null) return false;

/* first check attachments for validity */
$attachments = array();
if (!empty($_FILES) && $_FILES['attachment1']['error'] == 0) {
    $result = $discuss->hooks->load('post/attachment/verify',array(
        'attachments' => &$_FILES,
    ));
    if (!empty($result['errors'])) {
        $hook->addError('attachments',implode('<br />',$result['errors']));
    }
    $attachments = $result['attachments'];
}

/* if any errors, return */
if (!empty($hook->errors)) {
    return false;
}

$maxSize = (int)$modx->getOption('discuss.maximum_post_size',null,30000);
if ($maxSize > 0) {
    if ($maxSize > strlen($fields['message'])) $maxSize = strlen($fields['message']);
    $fields['message'] = substr($fields['message'],0,$maxSize);
}

/* create post object and set fields */
$post = $modx->newObject('disPost');
$post->fromArray($fields);
$post->set('author',$discuss->user->get('id'));
$post->set('parent',$post->get('id'));
$post->set('board',$post->get('board'));
$post->set('createdon',$discuss->now());
$post->set('ip',$discuss->getIp());

/* fire before post save event */
$rs = $modx->invokeEvent('OnDiscussBeforePostSave',array(
    'post' => &$post,
    'thread' => &$thread,
    'mode' => 'reply',
));
$canSave = $discuss->getEventResult($rs);
if (!empty($canSave)) {
    return $modx->error->failure($canSave);
}

/* save post */
if ($post->save() == false) {
    return $modx->error->failure($modx->lexicon('discuss.post_err_reply'));
}

/* upload attachments */
foreach ($attachments as $file) {
    $attachment = $modx->newObject('disPostAttachment');
    $attachment->set('post',$post->get('id'));
    $attachment->set('board',$post->get('board'));
    $attachment->set('filename',$file['name']);
    $attachment->set('filesize',$file['size']);
    $attachment->set('createdon',strftime('%Y-%m-%d %H:%M:%S'));

    if ($attachment->upload($file)) {
        $attachment->save();
    } else {
        $modx->log(modX::LOG_LEVEL_ERROR,'[Discuss] An error occurred while trying to upload the attachment: '.print_r($file,true));
    }
}

if (!empty($fields['notify'])) {
    $thread->addNotify($discuss->user->get('id'));
}

/* send out notifications */
$discuss->hooks->load('notifications/send',array(
    'board' => $post->get('board'),
    'post' => $post->get('id'),
    'thread' => $thread->get('id'),
    'title' => $post->get('title'),
    'subject' => $modx->getOption('discuss.notification_new_post_subject',null,'New Post'),
    'tpl' => $modx->getOption('discuss.notification_new_post_chunk',null,'emails/disNotificationEmail'),
));

/* fire post save event */
$modx->invokeEvent('OnDiscussPostSave',array(
    'post' => &$post,
    'thread' => &$thread,
    'mode' => 'reply',
));

$url = $discuss->url.'thread/?thread='.$thread->get('id').'#dis-post-'.$post->get('id');
$modx->sendRedirect($url);
return true;