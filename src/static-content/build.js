const fs = require('fs');
const path = require('path');
const process = require('process');
const readline = require('readline');

const startDirectory = process.argv[2] || 'html';
const partDirectory = process.argv[3] || 'part';
const outputDirectory = process.argv[4] || '../public';

const regexp = /{{(.*)}}/;

// Read files in startDirectory
fs.readdir(startDirectory, function(err, mainFiles) {
    exitIfError(err);

    if (!fs.existsSync(outputDirectory)) {
        fs.mkdirSync(outputDirectory);
    }

    mainFiles
        .filter(function(x) { return x != partDirectory; })
        .map(generateResult)
});

// Generate an output file for each file
function generateResult(file) {
    const fileName = path.join(outputDirectory, file);
    const output = fs.createWriteStream(fileName);
    const lineReader = readline.createInterface(
        { input: fs.createReadStream(path.join(startDirectory, file))
        });

    lineReader.on('line', function(line) {
        const match = line.match(regexp);
        var content = line + '\n';

        if (match && match.length == 2) {
            content = fs.readFileSync(path.join(startDirectory, match[1]));
        }
        output.write(content);
    });

    lineReader.on('close', function() {
        output.end();
        console.log(fileName + ' done');
    });
}

function exitIfError(err) {
    if (err !== null) {
        console.log(err);
        process.exit(1);
    }
}
