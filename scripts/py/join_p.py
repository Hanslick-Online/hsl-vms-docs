#!/usr/bin/env python

from acdh_tei_pyutils.tei import TeiReader, ET
import argparse
import sys
from pathlib import Path

# Define TEI namespace
TEI_NS = 'http://www.tei-c.org/ns/1.0'
NS = {'tei': TEI_NS}

# Register namespace to preserve prefix in output
ET.register_namespace('tei', TEI_NS)


def merge_paragraphs(root):
    """
    Find all p elements with prev="true" and merge them with previous p element.

    Args:
        root: The root element of the XML tree

    Returns:
        int: Number of paragraphs merged
    """
    merged_count = 0

    # Find all p elements with prev="true"
    prev_paragraphs = root.any_xpath('.//tei:p[@prev="true"]')
    for prev_p in prev_paragraphs:
        # Get parent of this paragraph
        parent = prev_p.getparent() if hasattr(prev_p, 'getparent') else find_parent(root, prev_p)

        if parent is None:
            print("Warning: Could not find parent for paragraph with prev='true'")
            continue

        # Find the previous p element
        previous_p = None
        elements_between = []
        found_current = False

        # Iterate through parent's children in reverse to find previous p
        for i, child in enumerate(parent):
            if child == prev_p:
                # Now look backwards for the previous p
                for j in range(i - 1, -1, -1):
                    if parent[j].tag == f'{{{TEI_NS}}}p':
                        previous_p = parent[j]
                        # Collect elements between the two p elements
                        elements_between = parent[j + 1:i]
                        break
                break

        if previous_p is None:
            print("Warning: Could not find previous p element for paragraph with prev='true'")
            continue

        # Merge content into previous paragraph
        # First, add any text at the end of previous_p
        if previous_p.tail:
            previous_p.tail = previous_p.tail.rstrip()

        # Add intermediate elements to previous_p
        for elem in elements_between:
            # Clone the element to avoid issues with moving
            cloned = ET.SubElement(previous_p, elem.tag, elem.attrib)
            cloned.text = elem.text
            cloned.tail = elem.tail
            # Copy any sub-elements
            for sub in elem:
                cloned.append(sub)

        # Add content from prev_p to previous_p
        # Handle text content
        if prev_p.text:
            if len(previous_p) > 0:
                # If previous_p has children, add text to tail of last child
                if previous_p[-1].tail:
                    previous_p[-1].tail += prev_p.text
                else:
                    previous_p[-1].tail = prev_p.text
            else:
                # If no children, add to text
                if previous_p.text:
                    previous_p.text += prev_p.text
                else:
                    previous_p.text = prev_p.text

        # Add all children from prev_p
        for child in prev_p:
            previous_p.append(child)

        # Remove the merged elements
        for elem in elements_between:
            parent.remove(elem)
        parent.remove(prev_p)

        merged_count += 1

    return merged_count


def find_parent(root, element):
    """
    Find parent of an element in the tree.

    Args:
        root: Root of the tree
        element: Element to find parent of

    Returns:
        Parent element or None
    """
    for parent in root.iter():
        if element in parent:
            return parent
    return None


def process_file(input_file, output_file=None):
    """
    Process a TEI XML file and merge paragraphs with prev="true".

    Args:
        input_file: Path to input XML file
        output_file: Path to output XML file (if None, overwrites input)

    Returns:
        bool: True if successful, False otherwise
    """
    try:
        # Parse the XML file
        doc = TeiReader(input_file)

        # Perform the merging
        merged_count = merge_paragraphs(doc)

        # Determine output file
        if output_file is None:
            output_file = input_file

        # Write the modified XML
        doc.tree_to_file(output_file)

        print(f"Successfully processed '{input_file}'")
        print(f"Merged {merged_count} paragraph(s)")
        print(f"Output written to '{output_file}'")

        return True

    except ET.ParseError as e:
        print(f"Error parsing XML file: {e}")
        return False
    except Exception as e:
        print(f"Error processing file: {e}")
        return False


def main():
    """Main function to handle command line arguments."""
    parser = argparse.ArgumentParser(
        description='Merge TEI paragraphs with prev="true" attribute'
    )
    parser.add_argument(
        'input',
        help='Input TEI XML file'
    )
    parser.add_argument(
        '-o', '--output',
        help='Output file (default: overwrite input file)'
    )
    parser.add_argument(
        '-b', '--backup',
        action='store_true',
        help='Create backup of input file before overwriting'
    )

    args = parser.parse_args()

    # Check if input file exists
    input_path = Path(args.input)
    if not input_path.exists():
        print(f"Error: Input file '{args.input}' not found")
        sys.exit(1)

    # Create backup if requested
    if args.backup and not args.output:
        backup_path = input_path.with_suffix(input_path.suffix + '.bak')
        try:
            backup_path.write_bytes(input_path.read_bytes())
            print(f"Created backup: {backup_path}")
        except Exception as e:
            print(f"Error creating backup: {e}")
            sys.exit(1)

    # Process the file
    success = process_file(args.input, args.output)

    if not success:
        sys.exit(1)


if __name__ == '__main__':
    main()
