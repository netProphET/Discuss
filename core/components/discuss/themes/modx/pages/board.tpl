[[+top]]

[[+aboveBoards]]


<ul class="CategoryListWithHeadings" style="[[+boards_toggle]]">
[[+boards]]
</ul>

[[+belowBoards]]

<div class="dis-threads">

	<h1 class="Category">[[+name]]</h1>

	<ul class="CategoryListWithHeadings">
		[[+posts]]
	</ul>



    [[+pagination]]
</div>


</div><!-- Close Content From Wrapper -->

[[+bottom]]



<div id="Panel">
				<hr class="line" />
    <div class="PanelBox">
        [[!+discuss.user.id:notempty=`<div class="Box GuestBox">
            <h4>Actions &amp; Info</h4>
			<p>[[+actionbuttons]]</p>
			[[+belowThreads]]
			<p>[[+moderators]]</p>
	    </div>`]]
        [[!+discuss.user.id:is=``:then=`<div class="Box GuestBox">
		    <h4>Actions &amp; Info</h4>
			<p><a href="[[~[[*id]]]]login" class="Button">Login to Post</a></p>
		</div>`]]

		[[!$post-sidebar?disection=`dis-support-opt`]]


    </div>
