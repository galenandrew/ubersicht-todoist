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
	# switch list type for header
	if obj.type is 'overdue'
		listName = 'Overdue'
	else
		switch obj.query
			when 'yesterday' then listName = 'Yesterday'
			when 'today' then listName = 'Today'
			when 'tomorrow' then listName = 'Tomorrow'
			else listName = 'Items'

	container.append "<h2 class='todoist-list-name'>#{listName}</h2>"
	container.append "<ul class='todoist-list'>"
	# iterate over list items
	for item in obj.data
		container.append "<li class='todoist-item #{item.priority}'>#{item.content}</li>"
	container.append "</ul>"

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

	.debug
		display: none
"""