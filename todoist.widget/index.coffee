# Config Variables
token = 'API_TOKEN'
queries = ["overdue","yesterday","today","tomorrow"]

# Local/Instance Variables
widgetName: 'Todo List'

# https://api.todoist.com/API/query?queries=["2014-4-29","overdue","p1","p2"]&token=270c632f7f192dcd58cbd3b8a20b86652bd08a9a
rawcommand: "curl -s 'https://api.todoist.com/API/query?queries=#{encodeURI JSON.stringify @queries}&token=#{@token}'"

command: "curl -s 'https://api.todoist.com/API/query?queries=#{encodeURI JSON.stringify @queries}&token=#{@token}'"

refreshFrequency: 1000 * 60 * 5 # refreshs every 5 minutes

render: () -> """
	<div class='todoist-widget'>
		<pre class="debug rawoutput"></pre>
		<h1 class='todoist-name'>#{@widgetName}</h1>
		<div class='todoist-wrapper'></div>
	</div>
"""

update: (rawoutput, domEl) ->
	# convert output to JSON
	output = JSON.parse rawoutput

	# grab dom elements
	container = $(domEl).find '.todoist-wrapper'
		.empty()
	raw = $(domEl).find '.rawoutput'
		.empty()
	raw.append rawoutput

	for obj in output
		@renderList obj, container

renderList: (obj, container) ->
	listHtml = ''

	# switch list type for header
	if obj.type is 'overdue'
		listName = 'Overdue'
	else
		switch obj.query
			when 'yesterday' then listName = 'Yesterday'
			when 'today' then listName = 'Today'
			when 'tomorrow' then listName = 'Tomorrow'
			else listName = 'Items'

	listHtml += "<h2 class='todoist-list-name'>#{listName}</h2>"
	unless obj.data.length
		listHtml += "<p class='todoist-list none'><i class='todoist-item'>No items</i></p>"
	else
		listHtml += "<ul class='todoist-list'>"
		# iterate over list items
		for item in obj.data
			listHtml += "<li class='todoist-item priority-#{item.priority}'>#{item.content}</li>"
		listHtml += "</ul>"

	container.append listHtml

style: """
	left: 10px
	color: #ffffff
	font-family: Helvetica Neue
	text-shadow: 0 0 1px rgba(#000, 0.5)
	font-size: 12px
	font-weight: 200

	h1
		font-size: 24px
		font-weight: 200
		border-bottom: 0.5px solid #ffffff
	h2
		font-size: 18px
		font-weight: 100

	.todoist-list-name
		margin-bottom: 5px

	.todoist-list
		margin-top: 5px

		&.none
			opacity: 0.2

	.todoist-item
		&.priority-4
			font-weight: 900
		&.priority-3
			font-weight: 400
			opacity: 0.8
		&.priority-2
			font-weight: 200
			opacity: 0.7
		&.priority-1
			font-weight: 150
			opacity: 0.6

	.debug
		display: none
"""