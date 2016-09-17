id = 1

Polymer

  is: 'conpinion-data-table-column'

  properties:
    name: {type: String, value: "#{id++}"}
    label: {type: String, value: ''}
