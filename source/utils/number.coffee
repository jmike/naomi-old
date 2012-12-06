###
Returns true if the supplied value represents a number.
@param {*} x
@return {Boolean}
@private
###
isNumeric = (x) -> not isNaN(x)

###
Returns true if the supplied value represents an integer.
@param {*} x
@return {Boolean}
@private
###
isInt = (x) -> x % 1 is 0

###
Returns true if the supplied value represents a non negative integer (including zero).
@param {*} x
@return {Boolean}
@private
###
isNonNegativeInt = (x) -> isInt(x) and x >= 0

###
Returns true if the supplied value represents a positive integer (excluding zero).
@param {*} x
@return {Boolean}
@private
###
isPositiveInt = (x) -> isInt(x) and x > 0

exports.isNumeric = isNumeric
exports.isInt = isInt
exports.isNonNegativeInt = isNonNegativeInt
exports.isPositiveInt = isPositiveInt