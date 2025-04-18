#!/usr/bin/env python3

import sys, os, shutil, time, math, re, stat
from optparse import OptionParser

import datetime
import fileReadHelp
import json
try:
    import annotate
except ImportError:
    sys.stdout.write('[Warning: "annotate" import failed, no annotations will be generated]\n')
    annotate = None

usage =  '%prog [options] <graphfiles>'
parser = OptionParser(usage=usage)
parser.add_option('-g', '--graphlist', dest='graphlist',
                  help='file with list of graphfiles', metavar='FILE')
parser.add_option('-t', '--testdir', dest='testdir',
                  help='test directory', metavar='DIR',
                  default='.')
parser.add_option('-o', '--outdir', dest='outdir',
                  help='output directory', metavar='DIR',
                  default=None)
parser.add_option('-p', '--perfdir', dest='perfdir',
                  help='performance data directory', metavar='DIR',
                  default=None)
parser.add_option('-n', '--name', dest='name',
                  help='Test platform name', metavar='NAME',
                  default=None)
parser.add_option('-s', '--startdate', dest='startdate',
                  help='graph start date', metavar='DATE')
parser.add_option('-e', '--enddate', dest='enddate',
                  help='graph end date', metavar='DATE')
parser.add_option('-a', '--alttitle', dest='alttitle', 
                  help='alternate/custom site title', 
                  metavar='NAME', default=None)
parser.add_option('-v', '--verbose', dest='verbose',
                  action='store_true', default=False)
parser.add_option('-d', '--debug', dest='debug',
                  action='store_true', default=False)
parser.add_option('-r', '--reduce', dest='g_reduce', type='choice',
                  metavar='STRATEGY', default='avg',
                  choices=['avg', 'med', 'min', 'max'])
parser.add_option('-x', '--no-bounds', dest='g_display_bounds',
                  action='store_false', default=True)
parser.add_option('-u', '--numericX', dest='numericX',
                  help='expect numbers (e.g. revisions), not dates,' +
                       ' for the X axis',
                  action='store_true', default=False)
parser.add_option('-m', '--configs', dest='multiConf',
                  help='comma separated list of configurations. ":v" after a '
                       'configuration makes it visible by default. e.g '
                       '"local:v,--no-local:v" will create graphs with series '
                       'duplicated for local and --no-local both of which will '
                       'be visible by default on the web page.',
                  default='')
parser.add_option('-f', '--addfile', dest='addfile',
                  help='comma-separated paths to files that should be copied '
                       'into the html directory.',
                  default='')

if annotate:
    parser.add_option('-j', '--annotate', dest='annotation_file',
                      default=None)

debug = False
verbose = False
numericX = False
multiConf = []
defaultMultiConf = []

def try_parse_float(value):
    try:
        # removes any trailing characters (units)
        return float(re.sub(r'[^\d,.]+$', '', value))
    except ValueError:
        return value

def parse_date(value, dateformat='%m/%d/%y'):
    if numericX:
        return value
    else:
        return time.strptime(value.strip(), dateformat)

def show_date(value=time.localtime()):
    if numericX:
        return value
    else:
        return time.strftime('%Y-%m-%d', value)

# converts a csv file to json. Converts the csv file to json where the json
# object has two members: the labels and the actual data formatted as required
# by dygraphs
def csv_to_json(csvFile, ginfo):
    data = parse_csv(csvFile)
    os.unlink(csvFile)

    # rename the csv file to indicate that it's a json file
    jsonFile = os.path.splitext(csvFile)[0]+'.json'
    ginfo.datfname = os.path.splitext(ginfo.datfname)[0]+'.json'

    # each label is stored in a single element array because of how it is
    # parsed, get rid of that array so labels is now a simple array of strings
    labels = [a[0] for a in data[0]]
    data = data[1:]

    lines = []
    for line in data:
        # like for the labels, strip the array surrounding the date
        curDate = line[0][0]
        dataForCurDate = line[1:]
        curLine = [curDate]
        # the data for a series on the current date is stored as ['val'],
        # ['low', 'med', 'high'], or ['']. Need to parse as floats, and turn
        # [''] (no data for this series on this date) into None so json.dumps
        # turns it into null. If we're not using custom bars (displayrange is
        # false) then our val will come in as ['val'] but we just want to store
        # the single value, not the single value in an array
        for seriesArr in dataForCurDate:
            if len(seriesArr) == 1 and seriesArr[0] == '':
                curLine.append(None)
            else:
                if (ginfo.displayrange):
                    curLine.append([try_parse_float(x) for x in seriesArr])
                else:
                    curLine.append(try_parse_float(seriesArr[0]))
        lines.append(curLine)

    # if there was no data in the csvFile, create an empty entry for todays
    # date. Dygraphs does not accept a zero length array for the data so we add
    # a single entry for today's date with null data for each series
    if len(lines) == 0:
        line = [None for label in labels]
        line[0] = show_date()
        lines.append(line)

    jsonObj = {'labels': labels, 'data': lines}
    with open(jsonFile, 'w') as f:
        f.write(json.dumps(jsonObj))

# Helper functions to parse/write/sort a dygraphs compatible csv file.
#
# Expected form of csv file is:
#
# Date,<perfKey1>,<perfKey2>
# YYYY-mm-dd,<key1Value>,<key2Value>
# YYYY-mm-dd,<key1Value>,<key2Value>
#
# where <keyXValue> is of the form 'val' for numtrials=1 (customBars are not
# being used), 'lowVal;medVal;highVal' for numTrials>1 (customBars are being
# used), or '' if there was no no value for that key for that date
#
# Parses a csv file of the above form into a list of the form:
#
# [[['Date'], ['perfKey1'], ['perfKey2']],
# [['YYYY-mm-dd'],[<key1Value>],[<key2Value>]],
# [['YYYY-mm-dd'],[<key1Value>],[<key2Value>]]]
#
# where <keyXValue> is either a single value as a string, 3 values (low, med,
# high) as strings, or the empty string if there was no value for that key for
# that date

def parse_csv(csvFile):
    lines = fileReadHelp.ReadFileWithComments(csvFile)

    data = []
    for line in lines:
        line = line.rstrip()
        if len(line) > 0:
            valuesString = line.split(',')
            values = []
            for valueString in valuesString:
                 values.append(valueString.split(';'))
            data.append(values)

    return data

def data_to_csv(data, csvFile):
    lines = []
    for values in data:
        line = []
        for value in values:
            line.append(';'.join(value))
        lines.append(','.join(line)+'\n')

    with open(csvFile, 'w') as f:
        f.writelines(lines)

# sorts a csv of the aforementioned form. Sorts a series' keys and it's
# corresponding values (column) from greatest to least in terms of a series
# most recent data.
# Takes:
#   Date,<perfKey1>,<perfKey2>
#   YYYY-mm-dd,1;2;3,0;1;2
#   YYYY-mm-dd,1;2;3,3;4;5
# and transforms it into:
#   Date,<perfKey2>,<perfKey1>
#   YYYY-mm-dd,0;1;2,1;2;3
#   YYYY-mm-dd,3;4;5,1;2;3
#
# also works for 'val', instead of 'low;med;high' and empty values: ''
def sort_csv(csvFile):
    data = parse_csv(csvFile)

    if len(data) == 1:
        return

    # transpose the data so that we can sort by row
    data = list(zip(*data))
    # remove the Date perfkey and the actual dates as they screw up sorting
    dates = data.pop(0)

    # sort function called on values of the form:
    #   [['perfKey1'],[<key1Value>],[<key1Value>]]
    # where keyXValue are of the form described above. sorts by the most recent
    # date, and grabs the middle value. returns -1 for empty values, so that
    # series with no recent data filter down to the bottom
    def parse_sortable_float(values):
        mostRecentValues = values[len(values)-1]
        value = mostRecentValues[len(mostRecentValues)//2]
        if value == '':
            return -1.0
        return try_parse_float(value)

    data.sort(key=lambda values: parse_sortable_float(values), reverse=True)

    # add the dates back in
    data.insert(0, dates)
    # untranspose the data
    data = list(zip(*data))

    data_to_csv(data, csvFile)

# Yield dateformat-ed dates in the range [start_date, end_date]
def date_range(start_date, end_date, dateformat='%Y-%m-%d'):
  cur_date = datetime.datetime.strptime(start_date, dateformat)
  end_date = datetime.datetime.strptime(end_date, dateformat)

  while cur_date <= end_date:
    yield cur_date.strftime(dateformat)
    cur_date += datetime.timedelta(days=1)

# Fill in missing dates in the csv file. Grabs the start and end date from the
# file, and ensures that we have an entry for every date in the range.
# We do this because annotations require an actual data point to attach to, so
# we make sure there will always be a day available
def fill_sparse_csv(csvFile):
    data = parse_csv(csvFile)
    keys = data.pop(0)
    if len(data) > 1:
        dates = list(zip(*data)).pop(0)
        dates = [date[0] for date in dates]
        if len(dates) > 1:
            start_date = dates[0]
            end_date = dates[-1]

            # for all the missing days append an empty entry to the end of the
            # data (we'll sort later to get things in the right order)
            missing_dates = set(date_range(start_date, end_date)) - set(dates)
            for date in missing_dates:
               # emptydate = [[date], [''], [''], ...]
               emptydate = [[date]] + [['']]*(len(keys)-1)
               data.append(emptydate)

        # sort our data, we don't need to convert our date strings to datetimes
        # because for ISO 8601 dates lexical order is also chronological order
        data.sort()

    data.insert(0, keys)
    data_to_csv(data, csvFile)


# Strips all but the first 'numseries' series from a csv file. Useful for
# things like compiler performance testing where you want to display the top 10
# passes. If multiple configurations are being used it grabs the series from
# the default configuration and then finds the other configurations for those
# series.
def strip_series(csvFile, numseries):
    data = parse_csv(csvFile)
    labels = [a[0] for a in data[0]]
    newData = []
    data = list(zip(*data))
    numFound = 0
    newData.append(data[0])
    if multiConf:
        defaultConf = multiConf[0]
        for i in range(1, len(labels)):
            if labels[i].endswith('(' + defaultConf + ')') and numFound < numseries:
                numFound+=1
                newData.append(data[i])
                for conf in multiConf[1:]:
                    confLabel = labels[i].replace('('+defaultConf+')','('+conf+')')
                    newData.append(data[labels.index(confLabel)])
    else:
        for i in range(1, numseries+1):
            newData.append(data[i])

    # untranspose the data
    data = list(zip(*newData))

    data_to_csv(data, csvFile)


# Find the series to attach annotations to. If there were multiple
# configurations, attach to a series in the default (first listed)
# configuration. Else attach to first series
def get_annotation_series(csvFile):
    data = parse_csv(csvFile)
    labels = [a[0] for a in data[0]]
    labels = labels[1:]

    annotation_series = labels[0]
    if multiConf:
        defaultConf = multiConf[0]
        for label in labels:
            if label.endswith('(' + defaultConf + ')'):
                annotation_series = label
                break

    return annotation_series



############

class CouldNotReadGraphFile(Exception):
    pass

# Global info about generating graphs
class GraphStuff:
    def __init__(self, _name, _testdir, _perfdir, _outdir, _startdate, _enddate,
                 _reduce, _display_bounds, _alttitle, _annotation_file):
        self.numGraphs = 0
        self.config_name = _name
        self.testdir = _testdir
        self.perfdir = _perfdir
        self.outdir = _outdir
        self.datdir = self.outdir+'/'+'CSVfiles'
        self.title = 'Chapel Performance Graphs'
        if _alttitle: 
            self.title = _alttitle
        if _name != None:
            self.title += ' for '+_name
        self.gfname = self.outdir+'/'+'graphdata.js'
        self.gfile = None
        self.suites = list()
        self.startdate = _startdate
        self.enddate = _enddate
        self._reduce = _reduce
        self.display_bounds = _display_bounds
        self.annotation_file = _annotation_file

    def init(self):
        if os.path.exists(self.outdir):
            if verbose:
                sys.stdout.write('Removing old directory %s...\n'%(self.outdir))
            try:
                shutil.rmtree(self.outdir)
            except OSError:
                sys.stderr.write('Error: Could not clean up directory: %s\n'%(self.outdir))
                raise
        if verbose:
            sys.stdout.write('Creating directory %s...\n'%(self.outdir))
        try:
            os.makedirs(self.outdir)
        except OSError:
            sys.stderr.write('ERROR: Could not (re)create directory: %s\n'%(self.outdir))
            raise
        if verbose:
            sys.stdout.write('Creating directory %s...\n'%(self.datdir))
        try:
            os.makedirs(self.datdir)
        except OSError:
            sys.stderr.write('ERROR: Could not create directory: %s\n'%(self.datdir))
            raise
        try:
            self.gfile = open(self.gfname, 'w')
        except IOError:
            sys.stderr.write('ERROR: Could not open file: %s\n'%(self.gfname))

        if annotate and self.annotation_file:
            try:
                self.all_annotations = annotate.load(self.annotation_file)
            except IOError:
                sys.stderr.write('ERROR: Could not open file: %s\n'%(self.annotation_file))
                raise
        else:
            self.all_annotations = None

        self.gfile.write('// AUTOMATICALLY GENERATED GRAPH DESCRIPTION\n')
        self.gfile.write('document.title = "%s";\n'%(self.title))
        self.gfile.write('var pageTitle = "%s";\n'%(self.title))
        runDate = time.strftime('%Y-%m-%d', time.localtime())
        self.gfile.write('var runDate= "%s";\n'%(runDate))
        self.gfile.write('var numericX = %s;\n'%(str(numericX).lower()))
        self.gfile.write('var configurations = [%s];\n' %(', '.join([ '" ('+conf+')"' for conf in multiConf])))
        self.gfile.write('var configurationsVis = [%s];\n' %(', '.join([ '"('+conf+')"' for conf in defaultMultiConf])))
        self.gfile.write('var allGraphs = [\n')
        self.firstGraph = True
        return 0

    def __str__(self):
        s = 'Number of unique graphs = '+str(self.numGraphs)
        s += 'test dir = '+self.testdir
        s += 'performance data dir = '+self.perfdir
        s += 'output dir = '+self.outdir
        s += 'start date = '+self.startdate
        s += 'end date = '+self.enddate
        s += ': '+str(len(self.dygarphs))+' dygraphs'
        return s

    def finish(self):
        if self.gfile:
            self.gfile.write('\n];\n')
            first = True
            self.gfile.write('var perfSuites = [\n')
            for s in self.suites:
                if not first:
                    self.gfile.write(',\n')
                else:
                    first = False
                self.gfile.write('{ "suite" : "%s" }'%(s))
            self.gfile.write('\n];\n')
            self.gfile.close()

    def genGraphInfo(self, ginfo):
        if not self.firstGraph:
            self.gfile.write(',\n')
        else:
            self.firstGraph = False

        series = ginfo.annotationSeries

        # generate the annotations for this graph
        if series and annotate and self.all_annotations and not numericX:
            ginfo.annotations = annotate.get(
                self.all_annotations, ginfo.name, series,
                parse_date(ginfo.startdate, '%Y-%m-%d'),
                parse_date(ginfo.enddate,'%Y-%m-%d'), self.config_name)

        self.gfile.write('{\n')
        if ginfo.title != '':
            self.gfile.write('   "title" : "%s",\n'%(ginfo.title))
        elif ginfo.graphname != '':
            sys.stdout.write('WARNING: \'graphname\' is deprecated.  Use \'graphtitle\' instead.\n')
            self.gfile.write('   "title" : "%s",\n'%(ginfo.graphname))
        else:
            sys.stdout.write('WARNING: No graph title found.\n')
            self.gfile.write('   "title" : "%s",\n'%(ginfo.name))
        suites =  (', '.join('"' + s + '"' for s in ginfo.suites if s))
        self.gfile.write('   "suites" : [%s],\n'%(suites))
        self.gfile.write('   "datfname" : "%s",\n'%(ginfo.datfname))
        self.gfile.write('   "ylabel" : "%s",\n'%(ginfo.ylabel))
        self.gfile.write('   "startdate" : "%s",\n'%(ginfo.startdate))
        self.gfile.write('   "enddate" : "%s",\n'%(ginfo.enddate))
        self.gfile.write('   "displayrange" : %s,\n'%(str(ginfo.displayrange).lower()))
        self.gfile.write('   "defaultexpand" : %s,\n'%(str(ginfo.expand).lower()))
        self.gfile.write('   "annotations" : [')
        if ginfo.annotations:
          self.gfile.write('\n      ')
          self.gfile.write(',\n      '.join(ginfo.annotations))
          self.gfile.write('\n   ')
        self.gfile.write(']\n')
        self.gfile.write('}')


    def genGraphStuff(self, fname, suites):
        if os.path.isabs(fname):
            fullFname = fname
        else:
            fullFname = self.testdir+'/'+fname
            if not os.path.exists(fullFname):
                fullFname = './'+fname
        if verbose:
            sys.stdout.write('Reading %s...\n'%(fullFname))
        lines=fileReadHelp.ReadFileWithComments(fullFname)
        if lines==None:
            sys.stdout.write('WARNING: Could not read graph description from %s.  Ignoring.\n'%(fullFname))
            raise CouldNotReadGraphFile

        basename = os.path.splitext(os.path.basename(fname))[0]

        graphs=list()
        currgraph=-1
        firstGraphNum = self.numGraphs
        for l in lines:
            key = l.split(':')[0].strip()
            rest = l[l.index(':')+1:].strip()
            if key == 'perfkeys' :
                if currgraph != -1:
                    try:
                        graphs[currgraph].generateGraphData(self, currgraph)
                    except (ValueError, IOError, OSError):
                        raise
                # new graph
                currgraph += 1
                graphs.append(GraphClass(basename, firstGraphNum+currgraph,
                    suites, self.startdate, self.enddate,
                    self._reduce, self.display_bounds))
                graphs[currgraph].perfkeys += [ s.strip() for s in rest.split(', ') ]
            elif key == 'graphkeys' :
                graphs[currgraph].graphkeys += [ s.strip() for s in rest.split(',') ]
            # files takes a list of the files to use per perfkey, while
            # repeat-files uses each of n files perkey/n times. So if you have
            # 10 perfkeys and 2 files listed, each file will be used 5 times
            elif key == 'files' :
                graphs[currgraph].datfilenames += [ s.strip() for s in rest.split(',') ]
            elif key == 'repeat-files' :
                dFiles = [ s.strip() for s in rest.split(',') ]
                if len(graphs[currgraph].perfkeys) % len(dFiles) != 0:
                    sys.stdout.write('[Warning: num .dat files did not evenly divide into num perfkeys for %s. Ignoring.]\n'%(fullFname))
                    return
                keysRange = range(0, (len(graphs[currgraph].perfkeys) // len(dFiles)))
                for dFile in dFiles:
                    graphs[currgraph].datfilenames += [ dFile for i in keysRange ]
            elif key == 'graphtitle':
                graphs[currgraph].title = rest.strip()
            elif key == 'graphname':
                # deprecated
                graphs[currgraph].graphname = rest.strip()
            elif key == 'ylabel':
                graphs[currgraph].ylabel = rest.strip()
            elif key == 'startdate':
                graphs[currgraph].startdate = parse_date(rest)
            elif key == 'enddate':
                graphs[currgraph].enddate = parse_date(rest)
            elif key == 'generate':
                graphs[currgraph].generate = [s if s != '' else self._reduce for s in re.sub(r'\s+', '', rest).split(',')]
                for strat in graphs[currgraph].generate:
                    if strat not in parser.get_option('-r').choices:
                        sys.stdout.write('WARNING: Invalid generate option {0} in {1}\n'.format(strat, fullFname))
            elif key == 'displayrange':
                graphs[currgraph].displayrange = rest.lower() in ('true', 't', '1', 'on', 'y', 'yes')
            # expansion is used to turn a single graph with multiple series into
            # multiple graphs where the first one is all the series combined and
            # the subsequent ones contain each series individually. -1 means 
            # expand all. Other numbers indicate the number of series to expand 
            elif key == 'defaultexpand':
                graphs[currgraph].expand = rest.lower() in ('true', 't', '1', 'on', 'y', 'yes')
            elif key == 'numseries':
                graphs[currgraph].numseries = int(rest.strip())
            elif key == 'sort':
                graphs[currgraph].sort = rest.lower() in ('true', 't', '1', 'on', 'y', 'yes')
            else:
                sys.stdout.write('WARNING: Invalid graph file key {0} in {1}\n'.format(key, fullFname))

        try:
            graphs[currgraph].generateGraphData(self, currgraph)
        except (ValueError, IOError, OSError):
            raise

        return (currgraph+1)


############

# graph class
class GraphClass:
    gid = 1
    def __init__(self, _name, _graphNum, _suites=[], _startdate=None,
                 _enddate=None, _reduce='avg', _displayrange=True, 
                 _expand=False, _sort=True):
        self.id = GraphClass.gid
        GraphClass.gid += 1
        self.name = _name.strip()
        self.srcdatfname = self.name+'.dat'
        self.title = ''
        self.suites = _suites
        self.graphname = ''
        self.ylabel = ''
        self.startdate = _startdate
        self.enddate = _enddate
        self.graphNum = _graphNum
        self.perfkeys = list()
        self.graphkeys = list()
        self.datfilenames = list()
        self.generate = list()
        self.displayrange = _displayrange
        self._reduce = _reduce
        self.expand = _expand
        self.numseries = -1
        self.sort = _sort
        self.annotations = []
        self.annotationSeries = ""

    def __str__(self):
        l  = 'Graph: '+str(self.name)+' (id='+str(self.id)+')\n'
        l += '\ttitle: '+self.title+'\n'
        if self.suites == None or self.suites == [] or self.suites == [None]:
            l += '\tsuites: none\n'
        else:
            l += '\tsuites: ['+','.join(self.suites)+']\n'
        l += '\tgraphname: '+self.graphname+'\n'
        l += '\tylabel: '+self.ylabel+'\n'
        if self.startdate != None:
            l += '\tstartdate: '+show_date(self.startdate)+'\n'
        else:
            l += '\tstartdate: Not specified\n'
        if self.enddate != None:
            l += '\tenddate: '+show_date(self.enddate)+'\n'
        else:
            l += '\tenddate: Not specified\n'
        l += '\tperfkeys: '+list.__str__(self.perfkeys)+'\n'
        l += '\tgraphkeys: '+list.__str__(self.graphkeys)+'\n'
        l += '\tdatfilenames: '+list.__str__(self.datfilenames)+'\n'
        l += '\tdisplayrange:'+str(self.displayrange).lower()+'\n'
        return l

    # For each unique data file
    class DatFileClass:
        def __init__(self, _filename):
            # lines will end up looking like:
            # lines[lineNum][trailNum][field]
            # where lineNum is the number after they are "merged"
            self.lines = []
            self.mykeys = {}
            try:
                self.dfile = open(_filename, 'r')
                # First line must be a comment and must be a tab separated list
                #  of the performance keys
                self.perfkeys = [ l.strip() for l in self.dfile.readline()[1:].split('\t') ]
            except IOError:
                pass
                # Allows some performance tests to be graphed when you aren't
                # running over every single performance test
            except:
                raise

        def add(self, _i, _k):
            # the _ith data stream comes from the column of the _kth perfkey
            self.mykeys[_i] = self.perfkeys.index(_k)

        def __str__(self):
            l  = '\tperfkeys: '+list.__str__(self.perfkeys)+'\n'
            l += '\tmykeys: '+dict.__str__(self.mykeys)+'\n'
            return l

        def __del__(self):
            if hasattr(self, 'dfile'):
                self.dfile.close()

    # Generate the new data file inline in CSV format
    def generateData(self, graphInfo, datfiles):
        # An alternative is to have an off-line process incrementally
        # update a CSV data file.  Since we would still have to open
        # potentially multiple data files and read thru them and look
        # at every line for the appropriate date, I opted for
        # regenerating.
        fname = graphInfo.datdir+'/'+self.datfname
        f = open(fname, 'w')
        f.write('Date,')
        for i in range(len(self.graphkeys)):
            f.write(self.graphkeys[i])
            if i < len(self.graphkeys)-1:
                f.write(',')
            else:
                f.write('\n')

        numKeys = len(self.perfkeys)
        # currLines stores the current merged line number of each dat file
        currLines = [0]*numKeys
        startdate = self.startdate
        enddate = self.enddate
        minDate = None

        first = True
        done = False
        for i in range(numKeys):
            # The file may be missing (in the case where only a subdirectory
            # has been tested for performance).  If so, we don't want to
            # try to access a non-existent datfile
            if self.datfilenames[i] in datfiles:
                df = datfiles[self.datfilenames[i]]
                for line in sorted(df.dfile):
                    line = line.strip()
                    if line == '' or line[0] == '#':
                        continue
                    fields = line.split()
                    myDate=parse_date(fields[0])
                    fields[0] = myDate
                    fields[1:] = [try_parse_float(x) for x in fields[1:]]
                    if df.lines and myDate == df.lines[-1][0][0]:
                        # append to the batch for that date
                        df.lines[-1].append(fields)
                    else:
                        # start a new batch
                        df.lines.append([fields])
                df.lines.sort()

        found_data = False
        while not done:
            done = True
            for i in range(numKeys):
                # The file may be missing (in the case where only a subdirectory
                # has been tested for performance).  If so, we don't want to
                # try to access a non-existent datfile
                if not self.datfilenames[i] in datfiles:
                    continue

                df = datfiles[self.datfilenames[i]]
                # find the min date
                if currLines[i] < len(df.lines):
                    done = False
                    myDate = df.lines[currLines[i]][0][0]
                    if minDate==None or myDate<minDate:
                        minDate = myDate

            if startdate==None:
                startdate = minDate

            if done:
                break

            # We didn't print anything last iteration if there was no data
            # found, so skip the new line in that case
            if not first and found_data:
                f.write('\n')
            else:
                first = False

            # write out the data for this date
            found_data = False
            line_to_write = show_date(minDate)
            for i in range(numKeys):
                if not self.datfilenames[i] in datfiles:
                    continue
                try:
                    df = datfiles[self.datfilenames[i]]
                    if currLines[i] < len(df.lines):
                        fields = list(zip(*df.lines[currLines[i]]))
                        myDate = fields[0][0]
                        if myDate == minDate:
                            # consume this line
                            line_to_write += ','
                            if len(fields)>df.mykeys[i] and '-' not in fields[df.mykeys[i]]:
                                fieldId = df.mykeys[i]
                                value = fields[fieldId][0]
                                if self.generate:
                                    method = self.generate[i]
                                else:
                                    method = self._reduce

                                if method == 'avg':
                                    value = math.fsum(fields[fieldId])/len(fields[fieldId])
                                elif method == 'med':
                                    slist = sorted(fields[fieldId])
                                    if len(fields[fieldId]) % 2 == 0:
                                        value = (slist[len(slist)/2]+slist[len(slist)/2-1])/2
                                    else:
                                        value = slist[len(slist)/2]
                                elif method == 'min':
                                    value = min(fields[fieldId])
                                elif method == 'max':
                                    value = max(fields[fieldId])

                                if self.displayrange:
                                    minval = min(fields[fieldId])
                                    maxval = max(fields[fieldId])
                                    line_to_write += "{0};{1};{2}".format(minval, value, maxval)
                                else:
                                    line_to_write += "{0}".format(value)
                                found_data = True
                            currLines[i] += 1
                        else:
                            # no data for this date
                            line_to_write += ','
                    else:
                        # no data for this date
                        line_to_write += ','
                except:
                    print('[Error parsing .dat file: {0}'.format(self.datfilenames[i]))
                    raise

            if found_data:
              f.write(line_to_write)

            if self.enddate==None:
                enddate = minDate
            else:
                enddate = self.enddate
            minDate = None

        f.write('\n')
        f.close()

        # sort the csv if sorting is enabled for this graph. This happens after
        # the file is created instead of above because the above process
        # appends to the file line by line and it wasn't clear to me how to get
        # it into a better form. If instead of writing out line by line, you
        # put the data into a list of the form described in the csv helper
        # functions section above, you can eliminate the intermediate step.
        if self.sort:
            sort_csv(fname)

        fill_sparse_csv(fname)

        if self.numseries > 0:
            strip_series(fname, self.numseries)

        self.annotationSeries = get_annotation_series(fname)

        csv_to_json(fname, self)

        if startdate == None:
            startdate = time.localtime()
        if enddate == None:
            self.enddate = startdate
        if graphInfo.startdate != None:
            self.startdate = show_date(graphInfo.startdate)
        else:
            self.startdate = show_date(startdate)
        if graphInfo.enddate != None:
            self.enddate = show_date(graphInfo.enddate)
        elif enddate != None:
            self.enddate = show_date(enddate)



    def generateGraphData(self, graphInfo, gnum):
        if debug:
            print('===')
            print(self)

        if verbose:
            sys.stdout.write('Generating graph data for %s (graph #%d)\n'%(self.name, gnum))

        self.datfname = self.name+str(gnum)+'.txt'

        nperfkeys = len(self.perfkeys)
        if nperfkeys != len(self.graphkeys):
            start = len(self.graphkeys)
            for i in range(start,nperfkeys):
                self.graphkeys.append(self.perfkeys[i])

        # strip trailing colons, equals, spaces, and dashes so graphkeys are
        # cleaner. We have a lot of them when graph keys come from perfkeys
        self.graphkeys = [key.rstrip(':= -') for key in self.graphkeys]

        for i in range(nperfkeys):
            for j in range(nperfkeys):
                if (i != j) and (self.graphkeys[i]==self.graphkeys[j]):
                    sys.stdout.write('WARNING: Duplicate graph keys (%s)\n'%(self.graphkeys[i]))

        defaultFilename = self.srcdatfname
        if nperfkeys != len(self.datfilenames):
            start = len(self.datfilenames)
            for i in range(start,nperfkeys):
                self.datfilenames.append(defaultFilename)

        # fix path to dat files
        for i in range(nperfkeys):
            fn = self.datfilenames[i]
            idx = fn.rfind('/')
            if idx != -1:
                if graphInfo.perfdir[0] == '/':
                    # absolute path (prepend path and strip relative path)
                    self.datfilenames[i] = graphInfo.perfdir+fn[idx:]
                else:
                    # relative path (find .dat file in the subdir)
                    self.datfilenames[i] = './'+fn[0:idx]+'/'+graphInfo.perfdir+fn[idx:]
            else:
                self.datfilenames[i] = graphInfo.perfdir+'/'+fn

        # this is the 'magic' for multiple configurations. It takes the info
        # for a graph and creates copies for each configuration.
        if multiConf:
            # copy datfiles, and keys to temp copies, and clear originals
            tempdatfilenames = self.datfilenames[0:]
            tempperfkeys = self.perfkeys[0:]
            tempgraphkeys = self.graphkeys[0:]
            self.datfilenames = []
            self.perfkeys = []
            self.graphkeys = []

            graphConfs = [ ' ('+conf+')' for conf in multiConf if conf ]
            for dat, perf, graph in zip(tempdatfilenames, tempperfkeys, tempgraphkeys):
                for conf, graphconf in zip(multiConf, graphConfs):
                    if conf == 'default':
                        conf = ''

                    datpath = os.path.dirname(dat)
                    datfile = os.path.basename(dat)
                    fullDatFile = os.path.join(datpath, conf, datfile)

                    # if we found the files for the current conf, add the
                    # datfile, perf key, and graph key (with conf appended)
                    if os.path.exists(fullDatFile):
                        self.datfilenames.append(fullDatFile)
                        self.perfkeys.append(perf)
                        self.graphkeys.append(graph + graphconf)
                    # if the .dat file wasn't found, then it's possible the
                    # test didn't run for this configuration. Try to find the
                    # .dat file for one of the configurations and copy the
                    # series (first line.) Dygraphs expects there to be a
                    # series for each configuration even if there's no data.
                    else:
                        for otherConf in multiConf:
                            if otherConf == 'default':
                                otherConf = ''
                            otherFullDatFile = os.path.join(datpath, otherConf, datfile)
                            if os.path.exists(otherFullDatFile):
                                firstline = ''
                                with open(otherFullDatFile, 'r') as f:
                                    firstline = f.readline()
                                if firstline:
                                    with open(fullDatFile, 'w') as f:
                                        f.write(firstline)
                    # if we still didn't find the file, it might be a test that
                    # doesn't really have multi-configurations (misc stats for
                    # compiler perf.) If there's a file not in a conf directory
                    # use it and don't append the conf to the graph key
                    if not os.path.exists(fullDatFile) and not 'default' in multiConf:
                        myDatFile = os.path.join(datpath, datfile)
                        if os.path.exists(myDatFile):
                            self.datfilenames.append(myDatFile)
                            self.perfkeys.append(perf)
                            self.graphkeys.append(graph)
                            break
                    # it's possible we still didn't fine the file, but if
                    # that's the case the test wasn't run for any configuration
                    # and we won't generate data for any series which won't
                    # bother dygraphs

            nperfkeys = len(self.perfkeys)

        # create a hashmap of open datfiles
        datfiles = {}
        for i in range(nperfkeys):
            d = self.datfilenames[i]
            if d not in datfiles:
                datfiles[d] = self.DatFileClass(d)
            try:
                if hasattr(datfiles[d], 'dfile'):
                    # May not have a dfile if the specific performance test
                    # was not previously run and dumped into this folder
                    # Should distinguish this case from cases where there are
                    # legitimately no perfkeys
                    datfiles[d].add(i, self.perfkeys[i])
                else:
                    # We don't have a dfile for that file name.  Delete the
                    # created DatFileClass so it doesn't mess us up
                    del datfiles[d]
            except ValueError:
                sys.stderr.write('ERROR: Could not find perfkey \'%s\' in %s\n'%(self.perfkeys[i], self.datfilenames[i]))
                raise

        # generate the new data files
        self.generateData(graphInfo, datfiles)
        graphInfo.genGraphInfo(self)

        for n, d in datfiles.items():
            del d


####################

def main():
    (options, args) = parser.parse_args()
    sys.stdout.write('Running genGraphs with %s\n'%(' '.join(sys.argv)))
    global debug
    debug = options.debug
    global verbose
    verbose = options.verbose
    global numericX
    numericX = options.numericX

    if options.perfdir != None:
        perfdir = options.perfdir
    else:
        perfdir = './perfdat/'+os.uname()[1]

    if options.outdir != None:
        outdir = options.outdir
    else:
        outdir = perfdir+'/html'

    if options.startdate != None:
        startdate = parse_date(options.startdate)
    else:
        startdate = None

    if options.enddate != None:
        enddate = parse_date(options.enddate)
    else:
       if numericX:
           enddate = None
       else:
           enddate = time.localtime()

    global multiConf
    global defaultMultiConf
    # process multiConf options. Format is 'conf1[:v][,conf2[:v]]*'
    # e.g. 'default:v,no-local:v', which will generate two configurations that
    # are visible by default. If 'v' isn't specified the series will not be
    # visible by default. If 'v' isn't specified for any series, the first conf
    # will be visible by default
    if options.multiConf:
        tempConf = options.multiConf.split(',')
        for confAndDefaultVis in tempConf:
            temp = confAndDefaultVis.split(':')
            conf = temp[0]
            multiConf.append(conf)
            if len(temp) > 1 and temp[1] == 'v':
                defaultMultiConf.append(conf)
        if len(defaultMultiConf) == 0:
            defaultMultiConf.append(multiConf[0])
    else:
        multiConf = []

    annotation_file = None
    if annotate:
        if options.annotation_file is not None:
            annotation_file = options.annotation_file
        else:
            af = os.path.join(options.testdir, 'ANNOTATIONS.yaml')
            if os.path.exists(af):
                annotation_file = af

    # This allows the graph webpage to have an alternate title. The default is
    # Chapel Performance Graphs, which is not always appropriate 
    if options.alttitle != None:
        alttitle = options.alttitle
    else:
        alttitle = None

    graphInfo = GraphStuff(options.name, options.testdir, perfdir, outdir,
        startdate, enddate, options.g_reduce, options.g_display_bounds,
        alttitle, annotation_file)
    graphInfo.init()

    # get the list of .graph files
    lines = list()
    # command line .graph files
    for a in args:
        lines.append(a)
    # .graph files from the specified  file
    graphlist = options.graphlist
    if graphlist != None:
        try:
            f = open(graphlist, 'r')
            try:
                lines += f.readlines()
            finally:
                f.close()
        except IOError:
            sys.stderr.write('ERROR: Could not open graph file: %s\n'%(graphlist))
            return -1
    
    currSuite = None
    numSuites = 0
    numGraphfiles = 0
    graphList = list()
    # determine the suite(s) for each graph 
    for line in lines:
        l = line.strip()
        if l != '':
            if l[0] != '#':
                # if a graph has already been seen, just append to the list of
                # suites it belongs to, else add it add it to the graphList
                graphnames = [x[0] for x in graphList]
                if graphnames.count(l):
                    if currSuite in graphList[graphnames.index(l)][1]:
                        sys.stdout.write('[Warning: duplicate graph "{0}" '
                            'found in suite "{1}"]\n'.format(l, currSuite))
                    graphList[graphnames.index(l)][1].append(currSuite)
                    # the suites at the top of our list our more often 'meta'
                    # suites that contains graphs from various suites. To keep
                    # the graphs that are logically related next to each other
                    # we push this graph to the end of the list 
                    tempGraph = graphList.pop(graphnames.index(l))
                    graphList.append(tempGraph)
                else: 
                    graphList.append((l, [currSuite]))
            else:
                # parse for suite name
                ls = l[1:].split(': ')
                if ls[0].strip() == 'suite':
                    currSuite = ls[1].rstrip()
                    graphInfo.suites.append(currSuite)
                    numSuites += 1
                    if verbose:
                        sys.stdout.write('suite: %s\n'%(currSuite))
  
    # generate the graphs 
    for graph in graphList: 
        try:
            graphInfo.genGraphStuff(graph[0], graph[1])
            numGraphfiles += 1
        except (CouldNotReadGraphFile):
            pass  # do not increment numGraphfiles
        except (ValueError, IOError, OSError):
            print("Error generating graph", graph)
            raise


    # Copy the index.html and support css and js files
    auxdir = os.path.dirname(os.path.realpath(__file__))+'/perf'
    copiedAllFiles = True
    try:
        shutil.copy(auxdir+'/index.html', outdir)
    except IOError:
        sys.stderr.write('WARNING: Could not copy index.html\n')
        copiedAllFiles = False
    try:
        shutil.copy(auxdir+'/perfgraph.css', outdir)
    except IOError:
        sys.stderr.write('WARNING: Could not copy perfgraph.css\n')
        copiedAllFiles = False
    try:
        shutil.copy(auxdir+'/perfgraph.js', outdir)
    except IOError:
        sys.stderr.write('WARNING: Could not copy perfgraph.js\n')
        copiedAllFiles = False

    graphInfo.finish()

    sys.stdout.write('Read %d graph files in %d suites\n'%(numGraphfiles, numSuites))

    if copiedAllFiles:
        with open(outdir + "/SUCCESS", 'w') as f:
            # do nothing, we just want to create the file so we know that no
            # errors that we currently detect occurred and all the requires
            # files were copied over. This is used to see if we should sync the
            # files over to the website.
            sys.stdout.write('Created SUCCESS file\n')

        #
        # recursively chmod the html/ directory for access via web servers
        #  - for directories, chmod u+rwx and go+rx
        #  - for directories, chmod go+r
        #
        for root, dirs, files in os.walk(outdir):
            os.chmod(root, stat.S_IRWXU | stat.S_IRGRP | stat.S_IXGRP | stat.S_IROTH | stat.S_IXOTH)
            for momo in dirs:
                os.chmod(os.path.join(root, momo), stat.S_IRWXU | stat.S_IRGRP | stat.S_IXGRP | stat.S_IROTH | stat.S_IXOTH)
            for momo in files:
                os.chmod(os.path.join(root, momo), stat.S_IRUSR | stat.S_IWUSR | stat.S_IRGRP | stat.S_IROTH)

        if len(options.addfile) > 0:
            for file in options.addfile.split(','):
                shutil.copy(file, outdir)
                sys.stdout.write('Copied %s into %s\n'%(file, outdir))


    return 0

if __name__ == '__main__':
    sys.exit(main())

