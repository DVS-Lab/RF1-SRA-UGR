for filename in r*; do
	[ -f "$filename" ] || continue
	mv "$filename" "${filename//r/}"
done

