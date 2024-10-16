# juicv, LaTeX CV class focused on compactness

The class is loosely inspired by the [AltaCV](https://github.com/liantze/AltaCV) class, though it has
diverged so significantly that none of the original code remains.
It has been completely reworked to align with my standards for both
visual and code aesthetics. Most optional features and customization
points have been removed to simplify the code, as they added complexity
without fully meeting my needs. The result is a streamlined,
non-customizable class. If you require more flexibility, the best
approach would be to fork the project and develop your own version.
The following CV has been compiled from the [examples/igrmk-net.tex](examples/igrmk-net.tex) file.

![CV](https://github.com/igrmk/juicv/releases/latest/download/example-igrmk-net.png)

## Build your own CV

1. Install Tectonic, for example, on macOS using Homebrew:
   ~~~bash
   brew install tectonic
   ~~~

2. Copy the `juicv.cls` class to your CV directory, along with `graphics` directory
   and both files from one of the examples (e.g., `igrmk-net.tex` and `igrmk-net.xmpdata`).
   Rename them to, say, `john.doe.tex` and `john.doe.xmpdata`.

3. Customize both files according to your own experience.

4. Run the following command to compile the CV:

   ~~~bash
   tectonic john.doe.tex
   ~~~

## Test your CV

1. We don't fully understand how Applicant Tracking Systems (ATS) work, but
   it’s clear that the first step is for them to correctly parse your CV.
   In PDFs created by \*TeX flavors, spaces are not explicitly encoded in the
   text. As a result, PDF parsers and viewers must use heuristics to determine
   where spaces should be.

   For instance, a parser like `mutool` handles this perfectly, while macOS
   Preview often struggles with accurately defining word, paragraph, and
   column boundaries. Obviously, ATSs can encounter the same problems.

   To test this, I recommend copying the text from your PDF using multiple
   PDF viewers and pasting it into a text editor to verify accuracy. You may
   find that some lines are merged without spaces. If this happens, try
   rephrasing those lines. Unfortunately, there is no reliable way in LaTeX
   to completely prevent this issue.

   You can also use various tools, like `mutool`, to verify proper parsing.

2. To evaluate your CV, you can use services like [Resume Worded](https://resumeworded.com/).
   While some of their suggestions may seem extreme — such as recommending numbers
   in every bullet point or using overly long, AI-generated phrases — the service
   is generally useful overall.

## Internals

1. Vector icons were chosen over the Font Awesome font because the font
   renders symbols, which, when copied from PDFs, appear as random Unicode
   characters. This can cause issues with Applicant Tracking Systems (ATS).
   Instead, the required SVG icons were downloaded from their website,
   placed in the `graphics` directory, and converted to PDF using the following commands.
   The second command, while not strictly necessary,
   converts PDF 1.7 to PDF 1.4 to prevent a warning.

   ~~~bash
   cairosvg icon.svg -o icon.pdf
   gs -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=icon-compat.pdf icon.pdf
   ~~~

2. Below is a visual explanation of how LaTeX section margins function in different contexts.
   In the figure, if A is positioned above B, it reflects their arrangement in the text.
   The arrow from A to B indicates that A contributes its margin to the distance between A and B.
   There are some nuances for consecutive section titles.
   Instead of implementing this myself,
   I used the LaTeX `@startsection` macro, which already includes this functionality.

   ~~~mermaid
   graph TD;
       ContentBefore1(Content Before) --> Section1(Section Title);
       Section1 --> ContentBefore1;

       SectionBefore2(Section Title Before) --> SectionAfter2(Section Title After);

       Section3(Section Title) --> ContentAfter3(Content After);
       ContentAfter3(Content After) --> Section3;
   ~~~

   Since events in the CV can exist without any content,
   I created a special event without content by copying the paragraph hook code from `ltsect.dtx`
   to make LaTeX recognize the event (which is a subsection) as having content.
