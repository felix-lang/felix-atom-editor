
module.exports =
class Provider
  selector: '.flx'
  disableForSelector: '.comment, .string'

  inclusionPriority: 1
  excludeLowerPriority: true

  filterSuggestions: false # false means do fuzzy search

  constructor: ->
    @showIcon = atom.config.get('autocomplete-plus.defaultProvider') is 'Symbol'

  findSuggestionsForPrefix: (completions, prefix) ->
    #return [] unless completions?

    suggestions = []
    for word in completions
      continue unless word and word.text and prefix and firstCharsEqual(word.text, prefix)
      suggestions.push
        iconHTML: if @showIcon then undefined else false
        type: word.type
        text: word.text
        snippet: word.snippet
        replacementPrefix: prefix
        rightLabel: word.name
        rightLabelHTML: word.rightLabelHTML
        leftLabel: word.leftLabel
        leftLabelHTML: word.leftLabelHTML
        description: word.description
        descriptionMoreURL: word.descriptionMoreURL

    suggestions.sort(ascendingPrefixComparator)
    suggestions

  getSuggestions: ({scopeDescriptor, prefix}) ->
      return unless prefix?.length
      completions = [
          {text:"println", type:"function", snippet:"println$ ${1:expr}; ${2:}", rightLabelHTML:"[T in Str] T &rarr; 0", description:"Prints a string to console with trailing newline", descriptionMoreURL:"#"},
          {text:"Some", type:"type", snippet:"Some(${1:expr}) ${2:}", rightLabelHTML:"[T] T", description:"Option type", descriptionMoreURL:"#"},
          {text:"None", type:"type", snippet:"None[${1:type}] ${2:}", rightLabelHTML:"[T] T", description:"Option type", descriptionMoreURL:"#"},
      ]
      @findSuggestionsForPrefix(completions, prefix)

  getPrefix: (editor, bufferPosition) ->
    # Whatever your prefix regex might be
    regex = /[\w0-9_-]+$/

    # Get the text for the line up to the triggered buffer position
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])

    # Match the regex to the line, and return the match
    line.match(regex)?[0] or ''

  dispose: ->

  ascendingPrefixComparator = (a, b) -> a.text.localeCompare(b.text)

  firstCharsEqual = (str1, str2) ->
    if str2.length > str1.length
      return false

    len = str2.length - 1
    for i in [0..len]
      if not (str1[i].toLowerCase() is str2[i].toLowerCase())
        return false
    true
