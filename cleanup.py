import os
import re

def cleanup_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # 1. Remove print/debugPrint/log statements (including multi-line)
    # We use a non-greedy match for the content between parens, but balanced parens are better.
    # However, simple re.DOTALL often works for these debug calls if they don't contain nested complex calls.
    for func in ['print', 'debugPrint', 'log']:
        # Match from start of line (with indent) to the semicolon
        # This regex handles multi-line if the statement ends with ); on its own line or at the end of a line.
        content = re.sub(rf'^\s*{func}\s*\(.*?\)\s*;\s*$', '', content, flags=re.MULTILINE | re.DOTALL)
        content = re.sub(rf'^\s*//\s*{func}\s*\(.*?\)\s*;\s*$', '', content, flags=re.MULTILINE | re.DOTALL)

    # 2. Remove unwanted comments (commented-out code blocks)
    lines = content.split('\n')
    new_lines = []
    
    # Heuristic for commented out code:
    # Starts with // and contains characteristic code symbols
    code_symbols = [';', '{', '}', '=>', ' = ', 'import ', 'class ', 'void ', 'final ', 'const ']
    exclude_keywords = ['TODO', 'FIXME', 'NOTE', 'http', 'https', 'Package:', 'Version:', 'Copyright', 'License']

    for line in lines:
        stripped = line.strip()
        if stripped.startswith('//'):
            # It's a comment. Check if it looks like code.
            comment_content = stripped[2:].strip()
            
            # If it's a very long block of commented out code (multiple lines ending with ;)
            # we should skip it.
            
            # If it ends with a semicolon, it's almost certainly code.
            if comment_content.endswith(';') or comment_content.endswith('{') or comment_content.endswith('}'):
                if not any(ex in comment_content for ex in exclude_keywords):
                    continue
            
            # If it contains complex code-like structures
            if ('(' in comment_content and ')' in comment_content and any(s in comment_content for s in [',', '.', 'new '])):
                if not any(ex in comment_content for ex in exclude_keywords):
                    continue

        new_lines.append(line)

    with open(filepath, 'w') as f:
        f.write('\n'.join(new_lines))

def main():
    for root, dirs, files in os.walk('lib'):
        for file in files:
            if file.endswith('.dart'):
                cleanup_file(os.path.join(root, file))

if __name__ == "__main__":
    main()
