
### Bio::EnsEMBL::Pipeline::Runnable::Finished_MiniEst2Genome

package Bio::EnsEMBL::Pipeline::Runnable::Finished_MiniEst2Genome;

use strict;
use Bio::EnsEMBL::Pipeline::Runnable::Finished_Est2Genome;

# Inherit from MiniEst2Genome
use Bio::EnsEMBL::Pipeline::Runnable::MiniEst2Genome;
use vars '@ISA';
@ISA = ('Bio::EnsEMBL::Pipeline::Runnable::MiniEst2Genome');

sub run_blaste2g {
    my( $self, $est, $features ) = @_;
    
    my $miniseq = $self->make_miniseq(@$features);
    my $hseq = $self->get_Sequence($est)
        or $self->throw("Can't fetch sequence for id '$est'");
    
    my $eg = new Bio::EnsEMBL::Pipeline::Runnable::Finished_Est2Genome(
        -genomic => $miniseq->get_cDNA_sequence,
        -est     => $hseq,
        );
    $eg->run;
    
    foreach my $fp ($eg->output) {
        my @converted = $miniseq->convert_FeaturePair($fp);
        if (@converted > 1) {
            warn "feature converts into '" . scalar(@converted) . "' > 1 features - ignoring\n";
        } else {            
            # convert_FeaturePair zaps strand and hseqname,
            # so we put them back here.
            my $new = $converted[0];
            $new->strand($fp->strand);
            $new->hseqname($fp->hseqname);
            
            $self->add_output(@converted);
        }
    }
}

1;

__END__

=head1 NAME - Bio::EnsEMBL::Pipeline::Runnable::Finished_MiniEst2Genome

=head1 AUTHOR

James Gilbert B<email> jgrg@sanger.ac.uk

