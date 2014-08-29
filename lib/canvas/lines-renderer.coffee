
module.exports =
class LinesRenderer
  constructor: ->

  renderLines: (lines, context, offsetRows) ->

  svg: ({content, width, height, css}) ->
    """
    <svg xmlns="http://www.w3.org/2000/svg" width="#{width}" height="#{height}">
      <style type="text/css"><![CDATA[#{css}]]></style>

      </style>
      <foreignObject width="100%" height="100%">
        #{content}
     </foreignObject>
    </svg>
    """

  css: ->
    return @cssCache if @cssCache?

    css = ''
    for k,v of document.styleSheets
      css += v.ownerNode.innerHTML if v.ownerNode?

    @cssCache = css
