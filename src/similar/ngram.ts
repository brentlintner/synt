const generate = (
  arr : string[],
  len = 1
) : string[] => {
  if (len > arr.length) len = 1
  if (len == 1) return arr

  const sets : string[] = []

  arr.forEach((token : string, index : number) => {
    const s_len = index + len
    if (s_len <= arr.length) {
      sets.push(arr.slice(index, s_len).join(""))
    }
  })

  return sets
}

export { generate }
